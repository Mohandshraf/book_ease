import 'package:book_ease/features/messages/data/models/chat_conversation_model.dart';
import 'package:book_ease/features/messages/data/models/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ConversationsLoaded extends ChatState {
  final List<ChatConversationModel> conversations;
  ConversationsLoaded(this.conversations);
}

class MessagesLoaded extends ChatState {
  final List<MessageModel> messages;
  MessagesLoaded(this.messages);
}

class MessageSentSuccess extends ChatState {}

class ChatFailure extends ChatState {
  final String errorMessage;
  ChatFailure(this.errorMessage);
}
