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
    emit(ChatLoading());
    try {
      await chatRepo.seedInitialConversations();
      _conversationsSub?.cancel();
      _conversationsSub = chatRepo.getConversations().listen(
        (conversations) {
          emit(ConversationsLoaded(conversations));
        },
        onError: (e) {
          emit(ChatFailure(e.toString()));
        },
      );
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  void getMessages(String otherUserId) {
    emit(ChatLoading());
    try {
      chatRepo.markAsRead(otherUserId);
      _messagesSub?.cancel();
      _messagesSub = chatRepo.getMessages(otherUserId).listen(
        (messages) {
          emit(MessagesLoaded(messages));
        },
        onError: (e) {
          emit(ChatFailure(e.toString()));
        },
      );
    } catch (e) {
      emit(ChatFailure(e.toString()));
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
      emit(ChatFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _conversationsSub?.cancel();
    _messagesSub?.cancel();
    return super.close();
  }
}
