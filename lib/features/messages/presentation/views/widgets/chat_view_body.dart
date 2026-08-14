import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_state.dart';
import 'package:book_ease/features/messages/data/models/message_model.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_action_bar.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_bubble.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatViewBody extends StatefulWidget {
  final String otherUserId;
  final String doctorName;
  final String? otherUserImage;
  final String? otherUserSpecialty;

  const ChatViewBody({
    super.key,
    required this.otherUserId,
    required this.doctorName,
    this.otherUserImage,
    this.otherUserSpecialty,
  });

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getMessages(widget.otherUserId);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    context.read<ChatCubit>().sendMessage(
          receiverId: widget.otherUserId,
          receiverName: widget.doctorName,
          messageText: text,
          receiverImage: widget.otherUserImage,
          receiverSpecialty: widget.otherUserSpecialty,
        );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return SafeArea(
      child: Column(
        children: [
          // 1. Header (back button, title, phone call)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ChatHeader(doctorName: widget.doctorName),
          ),
          const SizedBox(height: 10),

          // 2. Action Buttons Row (Appointment details, Reschedule)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ChatActionBar(),
          ),
          const SizedBox(height: 10),

          // 3. Messages List Area
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is MessagesLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff0B9B7B),
                    ),
                  );
                }

                final List<MessageModel> messages =
                    (state is MessagesLoaded) ? state.messages : [];

                if (messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Color(0xff94A3B8),
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Start conversation with ${widget.doctorName}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xff64748B),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUserId;
                    final timeStr = _formatTime(msg.timestamp);

                    return ChatBubble(
                      text: msg.messageText,
                      time: timeStr,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),

          // 4. Send Message Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F5F9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(
                            color: Color(0xff94A3B8),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xff0B9B7B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
