import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_state.dart';
import 'package:book_ease/features/messages/data/models/message_model.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_action_bar.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_bubble.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FocusNode _focusNode = FocusNode();
  MessageModel? _editingMessage;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getMessages(widget.otherUserId);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (_editingMessage != null && _editingMessage!.id != null) {
      context.read<ChatCubit>().editMessage(
            otherUserId: widget.otherUserId,
            messageId: _editingMessage!.id!,
            newText: text,
          );
      setState(() {
        _editingMessage = null;
      });
      _controller.clear();
      return;
    }

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

  void _cancelEditing() {
    setState(() {
      _editingMessage = null;
    });
    _controller.clear();
    _focusNode.unfocus();
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

  void _showMessageOptions(MessageModel msg, bool isMe) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xffCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Message snippet preview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xffE2E8F0)),
                    ),
                    child: Text(
                      msg.messageText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff475569),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                ListTile(
                  leading: const Icon(Icons.copy_rounded,
                      color: Color(0xff0B1F44)),
                  title: const Text(
                    "Copy text",
                    style: TextStyle(
                      color: Color(0xff0B1F44),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    Clipboard.setData(ClipboardData(text: msg.messageText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Message copied to clipboard"),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                if (isMe && msg.id != null) ...[
                  ListTile(
                    leading: const Icon(Icons.edit_rounded,
                        color: Color(0xff0B9B7B)),
                    title: const Text(
                      "Edit message",
                      style: TextStyle(
                        color: Color(0xff0B1F44),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      setState(() {
                        _editingMessage = msg;
                        _controller.text = msg.messageText;
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: _controller.text.length),
                        );
                      });
                      _focusNode.requestFocus();
                    },
                  ),
                ],
                if (msg.id != null) ...[
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded,
                        color: Colors.redAccent),
                    title: const Text(
                      "Delete message",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      _confirmDeleteMessage(msg);
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteMessage(MessageModel msg) {
    if (msg.id == null) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete Message",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff0B1F44)),
        ),
        content: const Text(
          "Are you sure you want to delete this message?",
          style: TextStyle(color: Color(0xff64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Color(0xff64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatCubit>().deleteMessage(
                    otherUserId: widget.otherUserId,
                    messageId: msg.id!,
                  );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Clear Chat Messages",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff0B1F44)),
        ),
        content: const Text(
          "Are you sure you want to clear all messages in this chat?",
          style: TextStyle(color: Color(0xff64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Color(0xff64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatCubit>().clearChatMessages(widget.otherUserId);
            },
            child: const Text("Clear", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConversationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete Chat",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff0B1F44)),
        ),
        content: const Text(
          "Are you sure you want to delete this chat conversation?",
          style: TextStyle(color: Color(0xff64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Color(0xff64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatCubit>().deleteConversation(widget.otherUserId);
              Navigator.maybePop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return SafeArea(
      child: Column(
        children: [
          // 1. Header (back button, title, phone call, more options)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ChatHeader(
              doctorName: widget.doctorName,
              onClearChatTap: _showClearChatDialog,
              onDeleteConversationTap: _showDeleteConversationDialog,
            ),
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
                if (state.messages.isNotEmpty) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatLoading && state.messages.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff0B9B7B),
                    ),
                  );
                }

                final List<MessageModel> messages = state.messages;

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
                      isEdited: msg.isEdited,
                      onLongPress: () => _showMessageOptions(msg, isMe),
                    );
                  },
                );
              },
            ),
          ),

          // 4. Send Message / Edit Message Input Bar
          Container(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_editingMessage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    color: const Color(0xffE2F9F0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_rounded,
                          color: Color(0xff0B9B7B),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Editing message",
                                style: TextStyle(
                                  color: Color(0xff0B9B7B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _editingMessage!.messageText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xff334155),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              size: 18, color: Color(0xff64748B)),
                          onPressed: _cancelEditing,
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              onSubmitted: (_) => _sendMessage(),
                              decoration: InputDecoration(
                                hintText: _editingMessage != null
                                    ? "Edit message..."
                                    : "Type a message...",
                                hintStyle: const TextStyle(
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
                            child: Icon(
                              _editingMessage != null
                                  ? Icons.check_rounded
                                  : Icons.send_rounded,
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
          ),
        ],
      ),
    );
  }
}
