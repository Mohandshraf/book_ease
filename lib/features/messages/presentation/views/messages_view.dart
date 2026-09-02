import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_state.dart';
import 'package:book_ease/features/messages/data/models/chat_conversation_model.dart';
import 'package:book_ease/features/messages/presentation/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().initConversations();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatConversationTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final chatDate = DateTime(dt.year, dt.month, dt.day);

    if (chatDate == today) {
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } else if (today.difference(chatDate).inDays == 1) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}';
    }
  }

  void _showDeleteConversationDialog(ChatConversationModel chat) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete Chat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          "Are you sure you want to delete the chat with ${chat.otherUserName}?",
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatCubit>().deleteConversation(chat.otherUserId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 140,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Messages",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(14),
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search messages...",
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading && state.conversations.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          List<ChatConversationModel> chats = state.conversations;

          if (_searchQuery.isNotEmpty) {
            chats = chats.where((c) {
              final nameMatch = c.otherUserName.toLowerCase().contains(
                _searchQuery,
              );
              final msgMatch = c.lastMessage.toLowerCase().contains(
                _searchQuery,
              );
              final specMatch = (c.otherUserSpecialty ?? '')
                  .toLowerCase()
                  .contains(_searchQuery);
              return nameMatch || msgMatch || specMatch;
            }).toList();
          }

          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.accentLilacLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                  const Gap(16),
                  const Text(
                    "No messages yet",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  const Text(
                    "Chat messages from providers will appear here",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
            itemCount: chats.length,
            separatorBuilder: (context, index) =>
                const Divider(color: AppColors.border, height: 1, indent: 84),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final timeStr = _formatConversationTime(chat.lastMessageTime);

              return Dismissible(
                key: Key(chat.otherUserId),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: AppColors.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      Gap(8),
                      Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                confirmDismiss: (direction) async {
                  _showDeleteConversationDialog(chat);
                  return false;
                },
                child: ScaleOnTap(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatView(
                          otherUserId: chat.otherUserId,
                          doctorName: chat.otherUserName,
                          otherUserImage: chat.otherUserImage,
                          otherUserSpecialty: chat.otherUserSpecialty,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: chat.unread
                        ? AppColors.primary.withValues(alpha: .03)
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundImage:
                                  chat.otherUserImage != null &&
                                      chat.otherUserImage!.isNotEmpty
                                  ? NetworkImage(chat.otherUserImage!)
                                  : null,
                              backgroundColor: AppColors.cardBackground,
                              child:
                                  (chat.otherUserImage == null ||
                                      chat.otherUserImage!.isEmpty)
                                  ? const Icon(
                                      Icons.person_rounded,
                                      color: AppColors.primary,
                                      size: 26,
                                    )
                                  : null,
                            ),
                            if (chat.unread)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  height: 14,
                                  width: 14,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Gap(14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    chat.otherUserName,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: chat.unread
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    timeStr,
                                    style: TextStyle(
                                      color: chat.unread
                                          ? AppColors.primary
                                          : AppColors.textMuted,
                                      fontSize: 12,
                                      fontWeight: chat.unread
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              if (chat.otherUserSpecialty != null &&
                                  chat.otherUserSpecialty!.isNotEmpty) ...[
                                const Gap(2),
                                Text(
                                  chat.otherUserSpecialty!,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              const Gap(4),
                              Text(
                                chat.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: chat.unread
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontSize: 13,
                                  fontWeight: chat.unread
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
