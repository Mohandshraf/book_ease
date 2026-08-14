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
  Future<void> markAsRead(String otherUserId);
  Future<void> seedInitialConversations();
}
