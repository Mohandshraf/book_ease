import 'dart:async';
import 'package:book_ease/features/messages/data/cubit/chat_state.dart';
import 'package:book_ease/features/messages/data/models/chat_conversation_model.dart';
import 'package:book_ease/features/messages/data/models/message_model.dart';
import 'package:book_ease/features/messages/data/repo/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;

  StreamSubscription<List<ChatConversationModel>>? _conversationsSub;
  StreamSubscription<List<MessageModel>>? _messagesSub;

  ChatCubit(this.chatRepo) : super(ChatInitial());

  void initConversations() async {
    if (state.conversations.isEmpty) {
      emit(ChatLoading(
        conversations: state.conversations,
        messages: state.messages,
        activeChatUserId: state.activeChatUserId,
      ));
    }
    try {
      await chatRepo.seedInitialConversations();
      _conversationsSub?.cancel();
      _conversationsSub = chatRepo.getConversations().listen(
        (conversations) {
          emit(ConversationsLoaded(
            conversations,
            messages: state.messages,
            activeChatUserId: state.activeChatUserId,
          ));
        },
        onError: (e) {
          emit(ChatFailure(
            e.toString(),
            conversations: state.conversations,
            messages: state.messages,
            activeChatUserId: state.activeChatUserId,
          ));
        },
      );
    } catch (e) {
      emit(ChatFailure(
        e.toString(),
        conversations: state.conversations,
        messages: state.messages,
        activeChatUserId: state.activeChatUserId,
      ));
    }
  }

  void getMessages(String otherUserId) {
    emit(ChatLoading(
      conversations: state.conversations,
      messages: state.activeChatUserId == otherUserId ? state.messages : const [],
      activeChatUserId: otherUserId,
    ));
    try {
      chatRepo.markAsRead(otherUserId);
      _messagesSub?.cancel();
      _messagesSub = chatRepo.getMessages(otherUserId).listen(
        (messages) {
          emit(MessagesLoaded(
            messages,
            conversations: state.conversations,
            activeChatUserId: otherUserId,
          ));
        },
        onError: (e) {
          emit(ChatFailure(
            e.toString(),
            conversations: state.conversations,
            messages: state.messages,
            activeChatUserId: otherUserId,
          ));
        },
      );
    } catch (e) {
      emit(ChatFailure(
        e.toString(),
        conversations: state.conversations,
        messages: state.messages,
        activeChatUserId: otherUserId,
      ));
    }
  }

  Future<void> sendMessage({
    required String receiverId,
    required String receiverName,
    required String messageText,
    String? receiverImage,
    String? receiverSpecialty,
  }) async {
    try {
      await chatRepo.sendMessage(
        receiverId: receiverId,
        receiverName: receiverName,
        messageText: messageText,
        receiverImage: receiverImage,
        receiverSpecialty: receiverSpecialty,
      );
    } catch (e) {
      emit(ChatFailure(
        e.toString(),
        conversations: state.conversations,
        messages: state.messages,
        activeChatUserId: state.activeChatUserId,
      ));
    }
  }

  Future<void> editMessage({
    required String otherUserId,
    required String messageId,
    required String newText,
  }) async {
    try {
      await chatRepo.editMessage(
        otherUserId: otherUserId,
        messageId: messageId,
        newText: newText,
      );
    } catch (e) {
      emit(ChatFailure(
        e.toString(),
        conversations: state.conversations,
        messages: state.messages,
        activeChatUserId: state.activeChatUserId,
      ));
    }
  }

  Future<void> deleteMessage({
    required String otherUserId,
    required String messageId,
  }) async {
    try {
      await chatRepo.deleteMessage(
        otherUserId: otherUserId,
        messageId: messageId,
      );
    } catch (e) {
      emit(ChatFailure(
        e.toString(),
        conversations: state.conversations,
        messages: state.messages,
        activeChatUserId: state.activeChatUserId,
      ));
    }
  }

  Future<void> deleteConversation(String otherUserId) async {
    try {
      await chatRepo.deleteConversation(otherUserId);
    } catch (e) {
      emit(ChatFailure(
        e.toString(),
        conversations: state.conversations,
        messages: state.messages,
        activeChatUserId: state.activeChatUserId,
      ));
    }
  }

  Future<void> clearChatMessages(String otherUserId) async {
    try {
      await chatRepo.clearChatMessages(otherUserId);
    } catch (e) {
      emit(ChatFailure(
        e.toString(),
        conversations: state.conversations,
        messages: state.messages,
        activeChatUserId: state.activeChatUserId,
      ));
    }
  }
  @override
  Future<void> close() {
    _conversationsSub?.cancel();
    _messagesSub?.cancel();
    return super.close();
  }
}
