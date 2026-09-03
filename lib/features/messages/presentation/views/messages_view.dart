import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/widgets/safe_image.dart';
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

  String _formatConversationTime(DateTime dt, BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final chatDate = DateTime(dt.year, dt.month, dt.day);

    if (chatDate == today) {
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return context.localizedTime('$hour:$minute $period');
    } else if (today.difference(chatDate).inDays == 1) {
      return context.tr('messages_yesterday');
    } else {
      final month = context.localizedMonthShort(dt.month);
      return '$month ${dt.day}';
    }
  }

  void _showDeleteConversationDialog(ChatConversationModel chat) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.tr('messages_delete_chat'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          "${context.tr('messages_delete_confirm')} ${chat.otherUserName}?",
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.tr('common_cancel'),
              style: const TextStyle(color: AppColors.textSecondary),
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
            child: Text(context.tr('common_delete'), style: const TextStyle(color: Colors.white)),
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
            Text(
              context.tr('messages_title'),
              style: const TextStyle(
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
                decoration: InputDecoration(
                  hintText: context.tr('messages_search_hint'),
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                  Text(
                    context.tr('messages_no_messages_yet'),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    context.tr('messages_empty_sub'),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
              final timeStr = _formatConversationTime(chat.lastMessageTime, context);

              return Dismissible(
                key: Key(chat.otherUserId),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: AppColors.error,
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsetsDirectional.only(end: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const Gap(8),
                      Text(
                        context.tr('common_delete'),
                        style: const TextStyle(
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
                        ? const Color(0xFFEF4444).withValues(alpha: .04)
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
                                  ? safeImageProvider(chat.otherUserImage!)
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
                                    color: const Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
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
                                  Expanded(
                                    child: Text(
                                      chat.otherUserName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 15,
                                        fontWeight: chat.unread
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    timeStr,
                                    style: TextStyle(
                                      color: chat.unread
                                          ? const Color(0xFFEF4444)
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      chat.lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: chat.unread
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                        fontSize: 13,
                                        fontWeight: chat.unread
                                            ? FontWeight.w700
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (chat.unread) ...[
                                    const Gap(8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Text(
                                        "1",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
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
