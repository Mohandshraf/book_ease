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
    });
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
    });
  }

  Future<void> sendMessage({
    required String receiverId,
    required String receiverName,
    required String messageText,
    String? receiverImage,
    String? receiverSpecialty,
  }) async {
    final senderId = currentUserId;
    final senderName = currentUserName;

    if (senderId.isEmpty || receiverId.isEmpty || messageText.trim().isEmpty) {
      return;
    }

    final chatId = getChatId(senderId, receiverId);
    final now = DateTime.now();

    final message = MessageModel(
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
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
      otherUserId: receiverId,
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
        .doc(receiverId)
        .set(senderConversation.toJson(), SetOptions(merge: true));

    // 3. Update receiver's conversation document
    final receiverConversation = ChatConversationModel(
      chatId: chatId,
      otherUserId: senderId,
      otherUserName: senderName,
      otherUserImage: _auth.currentUser?.photoURL,
      otherUserSpecialty: 'Patient',
      lastMessage: messageText.trim(),
      lastMessageTime: now,
      unread: true,
    );

    await _firestore
        .collection('users')
        .doc(receiverId)
        .collection('conversations')
        .doc(senderId)
        .set(receiverConversation.toJson(), SetOptions(merge: true));
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
    final uid = currentUserId;
    if (uid.isEmpty) return;

    final convsDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .get();

    if (convsDoc.docs.isEmpty) {
      final initialChats = [
        {
          'otherUserId': 'dr_sarah_mitchell',
          'otherUserName': 'Dr. Sarah Mitchell',
          'otherUserSpecialty': 'Cardiology Specialist',
          'otherUserImage':
              'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=200',
          'lastMessage':
              'Your lab results are ready. Let\'s discuss them during our appointment.',
        },
        {
          'otherUserId': 'city_medical_clinic',
          'otherUserName': 'City Medical Clinic',
          'otherUserSpecialty': 'Clinic Support',
          'otherUserImage':
              'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=200',
          'lastMessage':
              'Your booking for City Medical Clinic has been confirmed.',
        },
        {
          'otherUserId': 'dr_omar_hassan',
          'otherUserName': 'Dr. Omar Hassan',
          'otherUserSpecialty': 'Dental Care Specialist',
          'otherUserImage':
              'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=200',
          'lastMessage':
              'Please remember to bring your previous medical history documents.',
        },
      ];

      final now = DateTime.now();

      for (var chat in initialChats) {
        final otherId = chat['otherUserId']!;
        final chatId = getChatId(uid, otherId);
        final conv = ChatConversationModel(
          chatId: chatId,
          otherUserId: otherId,
          otherUserName: chat['otherUserName']!,
          otherUserSpecialty: chat['otherUserSpecialty'],
          otherUserImage: chat['otherUserImage'],
          lastMessage: chat['lastMessage']!,
          lastMessageTime: now,
          unread: false,
        );

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('conversations')
            .doc(otherId)
            .set(conv.toJson());
      }
    }
  }
}
