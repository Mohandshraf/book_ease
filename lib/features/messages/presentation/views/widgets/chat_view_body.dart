import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
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
import 'package:gap/gap.dart';

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
                    color: AppColors.border,
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
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      msg.messageText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const Gap(6),
                ListTile(
                  leading: const Icon(Icons.copy_rounded,
                      color: AppColors.textPrimary),
                  title: const Text(
                    "Copy text",
                    style: TextStyle(
                      color: AppColors.textPrimary,
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
                        color: AppColors.primary),
                    title: const Text(
                      "Edit message",
                      style: TextStyle(
                        color: AppColors.textPrimary,
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
                        color: AppColors.error),
                    title: const Text(
                      "Delete message",
                      style: TextStyle(
                        color: AppColors.error,
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
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        content: const Text(
          "Are you sure you want to delete this message?",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
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
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        content: const Text(
          "Are you sure you want to clear all messages in this chat?",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
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
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        content: const Text(
          "Are you sure you want to delete this chat conversation?",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
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
          const Gap(6),

          // 2. Action Buttons Row (Appointment details, Reschedule)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ChatActionBar(),
          ),
          const Gap(10),

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
                      color: AppColors.primary,
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
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.accentLilacLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                          const Gap(12),
                          Text(
                            "Start conversation with ${widget.doctorName}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
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
              border: const Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.03),
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
                    color: AppColors.accentLilacLight,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Editing message",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _editingMessage!.messageText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              size: 18, color: AppColors.textSecondary),
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
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.border),
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
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        ScaleOnTap(
                          onTap: _sendMessage,
                          child: Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primaryGradientStart,
                                  AppColors.primaryGradientEnd,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: .3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              _editingMessage != null
                                  ? Icons.check_rounded
                                  : Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
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
