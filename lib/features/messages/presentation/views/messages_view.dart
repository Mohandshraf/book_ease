import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_state.dart';
import 'package:book_ease/features/messages/data/models/chat_conversation_model.dart';
import 'package:book_ease/features/messages/presentation/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        'Dec'
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
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff0B1F44)),
        ),
        content: Text(
          "Are you sure you want to delete the chat with ${chat.otherUserName}?",
          style: const TextStyle(color: Color(0xff64748B)),
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
      backgroundColor: const Color(0xffF8FAFC),
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
                color: Color(0xff0B1F44),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xffF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search messages...",
                  hintStyle: TextStyle(color: Color(0xff94A3B8), fontSize: 15),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xff64748B)),
                  border: InputBorder.none,
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
              child: CircularProgressIndicator(color: Color(0xff0B9B7B)),
            );
          }

          List<ChatConversationModel> chats = state.conversations;

          if (_searchQuery.isNotEmpty) {
            chats = chats.where((c) {
              final nameMatch = c.otherUserName.toLowerCase().contains(_searchQuery);
              final msgMatch = c.lastMessage.toLowerCase().contains(_searchQuery);
              final specMatch = (c.otherUserSpecialty ?? '').toLowerCase().contains(_searchQuery);
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
                    decoration: const BoxDecoration(
                      color: Color(0xffE2F9F0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Color(0xff0B9B7B),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No messages yet",
                    style: TextStyle(
                      color: Color(0xff0B1F44),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Chat messages from providers will appear here",
                    style: TextStyle(
                      color: Color(0xff64748B),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: chats.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xffF1F5F9),
              height: 1,
              indent: 80,
            ),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final timeStr = _formatConversationTime(chat.lastMessageTime);

              return Dismissible(
                key: Key(chat.otherUserId),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                confirmDismiss: (direction) async {
                  _showDeleteConversationDialog(chat);
                  return false;
                },
                child: InkWell(
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
                  onLongPress: () => _showDeleteConversationDialog(chat),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: chat.otherUserImage != null &&
                                      chat.otherUserImage!.isNotEmpty
                                  ? NetworkImage(chat.otherUserImage!)
                                  : null,
                              backgroundColor: const Color(0xffE2E8F0),
                              child: (chat.otherUserImage == null ||
                                      chat.otherUserImage!.isEmpty)
                                  ? const Icon(Icons.person_rounded,
                                      color: Color(0xff64748B), size: 28)
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
                                    color: const Color(0xff0B9B7B),
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    chat.otherUserName,
                                    style: TextStyle(
                                      color: const Color(0xff0B1F44),
                                      fontSize: 16,
                                      fontWeight: chat.unread
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    timeStr,
                                    style: TextStyle(
                                      color: chat.unread
                                          ? const Color(0xff0B9B7B)
                                          : const Color(0xff94A3B8),
                                      fontSize: 13,
                                      fontWeight: chat.unread
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              if (chat.otherUserSpecialty != null &&
                                  chat.otherUserSpecialty!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  chat.otherUserSpecialty!,
                                  style: const TextStyle(
                                    color: Color(0xff64748B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 6),
                              Text(
                                chat.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: chat.unread
                                      ? const Color(0xff334155)
                                      : const Color(0xff64748B),
                                  fontSize: 14,
                                  fontWeight: chat.unread
                                      ? FontWeight.w500
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

