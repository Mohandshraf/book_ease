import 'package:book_ease/features/messages/data/models/chat_conversation_model.dart';
import 'package:book_ease/features/messages/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser?.uid ?? '';
  String get currentUserName =>
      _auth.currentUser?.displayName ?? 'User';

  String getChatId(String uid1, String uid2) {
    final list = [uid1, uid2]..sort();
    return list.join('_');
  }

  Stream<List<ChatConversationModel>> getConversationsStream() {
    final uid = currentUserId;
    if (uid.isEmpty) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatConversationModel.fromJson(doc.data()))
          .toList();
    }).handleError((_) => <ChatConversationModel>[]);
  }

  Stream<List<MessageModel>> getMessagesStream(String otherUserId) {
    final uid = currentUserId;
    if (uid.isEmpty || otherUserId.isEmpty) return Stream.value([]);

    final chatId = getChatId(uid, otherUserId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data(), doc.id))
          .toList();
    }).handleError((_) => <MessageModel>[]);
  }

  Future<void> sendMessage({
    required String receiverId,
    required String receiverName,
    required String messageText,
    String? receiverImage,
    String? receiverSpecialty,
    String? senderIdOverride,
    String? senderNameOverride,
    String? senderImageOverride,
    String? senderSpecialtyOverride,
  }) async {
    final senderId = (senderIdOverride != null && senderIdOverride.isNotEmpty)
        ? senderIdOverride
        : currentUserId;
    if (senderId.isEmpty || receiverId.isEmpty || messageText.trim().isEmpty) {
      return;
    }

    String senderName = (senderNameOverride != null && senderNameOverride.isNotEmpty)
        ? senderNameOverride
        : currentUserName;
    String? senderImage = senderImageOverride ?? _auth.currentUser?.photoURL;
    try {
      final userDoc = await _firestore.collection('users').doc(senderId).get();
      if (userDoc.exists && userDoc.data() != null) {
        final docName = userDoc.data()!['name'] as String?;
        if (docName != null && docName.trim().isNotEmpty && (senderNameOverride == null || senderNameOverride.isEmpty)) {
          senderName = docName.trim();
        }
        final docImage = userDoc.data()!['profileImage'] ?? userDoc.data()!['photoUrl'];
        if (docImage != null && docImage.toString().trim().isNotEmpty && senderImage == null) {
          senderImage = docImage.toString().trim();
        }
      }
    } catch (_) {}

    // Resolve targetReceiverId if receiverId is a doctor's name or mock identifier
    String targetReceiverId = receiverId;
    if (targetReceiverId == receiverName ||
        targetReceiverId.startsWith("doc_") ||
        targetReceiverId.contains(" ")) {
      try {
        final query = await _firestore
            .collection('users')
            .where('name', isEqualTo: receiverName)
            .limit(1)
            .get();
        if (query.docs.isNotEmpty) {
          targetReceiverId = query.docs.first.id;
        }
      } catch (_) {}
    }

    final chatId = getChatId(senderId, targetReceiverId);
    final now = DateTime.now();

    final message = MessageModel(
      senderId: senderId,
      senderName: senderName,
      receiverId: targetReceiverId,
      receiverName: receiverName,
      messageText: messageText.trim(),
      timestamp: now,
    );

    // 1. Add message to chats/{chatId}/messages
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toJson());

    // 2. Update sender's conversation document
    final senderConversation = ChatConversationModel(
      chatId: chatId,
      otherUserId: targetReceiverId,
      otherUserName: receiverName,
      otherUserImage: receiverImage,
      otherUserSpecialty: receiverSpecialty,
      lastMessage: messageText.trim(),
      lastMessageTime: now,
      unread: false,
    );

    await _firestore
        .collection('users')
        .doc(senderId)
        .collection('conversations')
        .doc(targetReceiverId)
        .set(senderConversation.toJson(), SetOptions(merge: true));

    // If targetReceiverId was different from original receiverId, also ensure original is set for sender
    if (targetReceiverId != receiverId) {
      await _firestore
          .collection('users')
          .doc(senderId)
          .collection('conversations')
          .doc(receiverId)
          .set(senderConversation.toJson(), SetOptions(merge: true));
    }

    // 3. Update receiver's conversation document (Mark as UNREAD so red badge appears)
    final receiverConversation = ChatConversationModel(
      chatId: chatId,
      otherUserId: senderId,
      otherUserName: senderName,
      otherUserImage: senderImage,
      otherUserSpecialty: senderSpecialtyOverride ?? 'Patient',
      lastMessage: messageText.trim(),
      lastMessageTime: now,
      unread: true,
    );

    await _firestore
        .collection('users')
        .doc(targetReceiverId)
        .collection('conversations')
        .doc(senderId)
        .set(receiverConversation.toJson(), SetOptions(merge: true));

    if (targetReceiverId != receiverId) {
      await _firestore
          .collection('users')
          .doc(receiverId)
          .collection('conversations')
          .doc(senderId)
          .set(receiverConversation.toJson(), SetOptions(merge: true))
          .catchError((_) {});
    }

    // Also send in-app notification to receiver
    try {
      await _firestore.collection('notifications').add({
        'userId': targetReceiverId,
        'title': 'New Message from $senderName',
        'body': messageText.trim(),
        'type': 'new_message',
        'relatedId': senderId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  Future<void> markConversationAsRead(String otherUserId) async {
    final uid = currentUserId;
    if (uid.isEmpty || otherUserId.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .doc(otherUserId)
        .update({'unread': false}).catchError((_) {});
  }


  Future<void> editMessage({
    required String otherUserId,
    required String messageId,
    required String newText,
  }) async {
    final uid = currentUserId;
    if (uid.isEmpty ||
        otherUserId.isEmpty ||
        messageId.isEmpty ||
        newText.trim().isEmpty) {
      return;
    }

    final chatId = getChatId(uid, otherUserId);
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    await messageRef.update({
      'messageText': newText.trim(),
      'isEdited': true,
    });

    // Check if this was the latest message and update conversations if needed
    final latestMessages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (latestMessages.docs.isNotEmpty &&
        latestMessages.docs.first.id == messageId) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('conversations')
          .doc(otherUserId)
          .update({'lastMessage': newText.trim()}).catchError((_) {});

      await _firestore
          .collection('users')
          .doc(otherUserId)
          .collection('conversations')
          .doc(uid)
          .update({'lastMessage': newText.trim()}).catchError((_) {});
    }
  }

  Future<void> deleteMessage({
    required String otherUserId,
    required String messageId,
  }) async {
    final uid = currentUserId;
    if (uid.isEmpty || otherUserId.isEmpty || messageId.isEmpty) {
      return;
    }

    final chatId = getChatId(uid, otherUserId);
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();

    // Update conversation last message with remaining latest message
    final remainingMessages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    String lastMsg = 'No messages';
    DateTime lastTime = DateTime.now();

    if (remainingMessages.docs.isNotEmpty) {
      final data = remainingMessages.docs.first.data();
      lastMsg = data['messageText'] ?? '';
      if (data['timestamp'] is Timestamp) {
        lastTime = (data['timestamp'] as Timestamp).toDate();
      }
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .doc(otherUserId)
        .update({
      'lastMessage': lastMsg,
      'lastMessageTime': Timestamp.fromDate(lastTime),
    }).catchError((_) {});

    await _firestore
        .collection('users')
        .doc(otherUserId)
        .collection('conversations')
        .doc(uid)
        .update({
      'lastMessage': lastMsg,
      'lastMessageTime': Timestamp.fromDate(lastTime),
    }).catchError((_) {});
  }

  Future<void> deleteConversation(String otherUserId) async {
    final uid = currentUserId;
    if (uid.isEmpty || otherUserId.isEmpty) {
      return;
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .doc(otherUserId)
        .delete();
  }

  Future<void> clearChatMessages(String otherUserId) async {
    final uid = currentUserId;
    if (uid.isEmpty || otherUserId.isEmpty) {
      return;
    }

    final chatId = getChatId(uid, otherUserId);
    final messagesSnapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    final batch = _firestore.batch();
    for (var doc in messagesSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .doc(otherUserId)
        .update({
      'lastMessage': 'Chat cleared',
      'lastMessageTime': Timestamp.now(),
    }).catchError((_) {});
  }

  Future<void> seedInitialConversationsIfEmpty() async {
    // No mock seed data - only real user conversations
  }
}
