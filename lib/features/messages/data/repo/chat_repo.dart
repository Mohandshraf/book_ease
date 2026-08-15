import 'package:book_ease/features/messages/data/models/chat_conversation_model.dart';
import 'package:book_ease/features/messages/data/models/message_model.dart';

abstract class ChatRepo {
  Stream<List<ChatConversationModel>> getConversations();
  Stream<List<MessageModel>> getMessages(String otherUserId);
  Future<void> sendMessage({
    required String receiverId,
    required String receiverName,
    required String messageText,
    String? receiverImage,
    String? receiverSpecialty,
  });
  Future<void> editMessage({
    required String otherUserId,
    required String messageId,
    required String newText,
  });
  Future<void> deleteMessage({
    required String otherUserId,
    required String messageId,
  });
  Future<void> deleteConversation(String otherUserId);
  Future<void> clearChatMessages(String otherUserId);
  Future<void> markAsRead(String otherUserId);
  Future<void> seedInitialConversations();
}
