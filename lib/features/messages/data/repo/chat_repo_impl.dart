import 'package:book_ease/features/messages/data/models/chat_conversation_model.dart';
import 'package:book_ease/features/messages/data/models/message_model.dart';
import 'package:book_ease/features/messages/data/repo/chat_repo.dart';
import 'package:book_ease/features/messages/data/services/chat_services.dart';

class ChatRepoImpl implements ChatRepo {
  final ChatServices _chatServices;

  ChatRepoImpl([ChatServices? chatServices])
      : _chatServices = chatServices ?? ChatServices();

  @override
  Stream<List<ChatConversationModel>> getConversations() {
    return _chatServices.getConversationsStream();
  }

  @override
  Stream<List<MessageModel>> getMessages(String otherUserId) {
    return _chatServices.getMessagesStream(otherUserId);
  }

  @override
  Future<void> sendMessage({
    required String receiverId,
    required String receiverName,
    required String messageText,
    String? receiverImage,
    String? receiverSpecialty,
  }) async {
    await _chatServices.sendMessage(
      receiverId: receiverId,
      receiverName: receiverName,
      messageText: messageText,
      receiverImage: receiverImage,
      receiverSpecialty: receiverSpecialty,
    );
  }

  @override
  Future<void> editMessage({
    required String otherUserId,
    required String messageId,
    required String newText,
  }) async {
    await _chatServices.editMessage(
      otherUserId: otherUserId,
      messageId: messageId,
      newText: newText,
    );
  }

  @override
  Future<void> deleteMessage({
    required String otherUserId,
    required String messageId,
  }) async {
    await _chatServices.deleteMessage(
      otherUserId: otherUserId,
      messageId: messageId,
    );
  }

  @override
  Future<void> deleteConversation(String otherUserId) async {
    await _chatServices.deleteConversation(otherUserId);
  }

  @override
  Future<void> clearChatMessages(String otherUserId) async {
    await _chatServices.clearChatMessages(otherUserId);
  }

  @override
  Future<void> markAsRead(String otherUserId) async {
    await _chatServices.markConversationAsRead(otherUserId);
  }

  @override
  Future<void> seedInitialConversations() async {
    await _chatServices.seedInitialConversationsIfEmpty();
  }
}
