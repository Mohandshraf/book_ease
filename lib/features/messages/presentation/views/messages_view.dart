import 'package:book_ease/features/messages/presentation/views/chat_view.dart';
import 'package:flutter/material.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  final List<Map<String, dynamic>> chats = const [
    {
      "name": "Dr. Sarah Mitchell",
      "specialty": "Cardiology Specialist",
      "lastMessage": "Your lab results are ready. Let's discuss them during our appointment.",
      "time": "10:30 AM",
      "unread": true,
      "image": "https://picsum.photos/id/64/200",
    },
    {
      "name": "City Medical Clinic",
      "specialty": "Clinic Support",
      "lastMessage": "Your booking for City Medical Clinic has been confirmed.",
      "time": "Yesterday",
      "unread": false,
      "image": "https://picsum.photos/id/100/200",
    },
    {
      "name": "Dr. Emily Stone",
      "specialty": "Pediatric Dentist",
      "lastMessage": "Please remember to bring your previous medical history documents.",
      "time": "Jul 15",
      "unread": false,
      "image": "https://picsum.photos/id/102/200",
    },
  ];

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
              child: const TextField(
                decoration: InputDecoration(
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
      body: chats.isEmpty
          ? Center(
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
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: chats.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xffF1F5F9),
                height: 1,
                indent: 80,
              ),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatView(doctorName: chat["name"]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(chat["image"]),
                              backgroundColor: const Color(0xffE2E8F0),
                            ),
                            if (chat["unread"])
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
                                    chat["name"],
                                    style: TextStyle(
                                      color: const Color(0xff0B1F44),
                                      fontSize: 16,
                                      fontWeight: chat["unread"]
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    chat["time"],
                                    style: TextStyle(
                                      color: chat["unread"]
                                          ? const Color(0xff0B9B7B)
                                          : const Color(0xff94A3B8),
                                      fontSize: 13,
                                      fontWeight: chat["unread"]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                chat["specialty"],
                                style: const TextStyle(
                                  color: Color(0xff64748B),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                chat["lastMessage"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: chat["unread"]
                                      ? const Color(0xff334155)
                                      : const Color(0xff64748B),
                                  fontSize: 14,
                                  fontWeight: chat["unread"]
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
                );
              },
            ),
    );
  }
}
