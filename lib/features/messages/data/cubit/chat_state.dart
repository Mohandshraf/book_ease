import 'package:book_ease/features/messages/data/models/chat_conversation_model.dart';
import 'package:book_ease/features/messages/data/models/message_model.dart';

abstract class ChatState {
  final List<ChatConversationModel> conversations;
  final List<MessageModel> messages;
  final String? activeChatUserId;

  const ChatState({
    this.conversations = const [],
    this.messages = const [],
    this.activeChatUserId,
  });
}

class ChatInitial extends ChatState {
  const ChatInitial() : super();
}

class ChatLoading extends ChatState {
  const ChatLoading({
    super.conversations,
    super.messages,
    super.activeChatUserId,
  });
}

class ChatLoaded extends ChatState {
  const ChatLoaded({
    super.conversations,
    super.messages,
    super.activeChatUserId,
  });

  ChatLoaded copyWith({
    List<ChatConversationModel>? conversations,
    List<MessageModel>? messages,
    String? activeChatUserId,
  }) {
    return ChatLoaded(
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      activeChatUserId: activeChatUserId ?? this.activeChatUserId,
    );
  }
}

class ConversationsLoaded extends ChatState {
  const ConversationsLoaded(
    List<ChatConversationModel> conversations, {
    super.messages,
    super.activeChatUserId,
  }) : super(conversations: conversations);
}

class MessagesLoaded extends ChatState {
  const MessagesLoaded(
    List<MessageModel> messages, {
    super.conversations,
    super.activeChatUserId,
  }) : super(messages: messages);
}

class MessageSentSuccess extends ChatState {
  const MessageSentSuccess({
    super.conversations,
    super.messages,
    super.activeChatUserId,
  });
}

class ChatFailure extends ChatState {
  final String errorMessage;
  const ChatFailure(
    this.errorMessage, {
    super.conversations,
    super.messages,
    super.activeChatUserId,
  });
}
