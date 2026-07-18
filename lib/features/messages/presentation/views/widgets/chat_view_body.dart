import 'package:book_ease/features/messages/presentation/views/widgets/chat_action_bar.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_bubble.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_header.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_typing_indicator.dart';
import 'package:flutter/material.dart';

class ChatViewBody extends StatelessWidget {
  final String doctorName;

  const ChatViewBody({
    super.key,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // 1. Header (back button, title, phone call)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ChatHeader(doctorName: doctorName),
          ),
          const SizedBox(height: 10),

          // 2. Action Buttons Row (Appointment details, Reschedule)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ChatActionBar(),
          ),
          const SizedBox(height: 20),

          // 3. Messages List Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timestamp label
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Today, 9:41 AM",
                        style: TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // Incoming Doctor message
                  const ChatBubble(
                    text: "Hello Alex, how can I help before your appointment?",
                    time: "9:41 AM",
                    isMe: false,
                  ),

                  // Outgoing Patient message
                  const ChatBubble(
                    text: "Hi Dr. Sarah, is there anything I should bring?",
                    time: "9:43 AM",
                    isMe: true,
                  ),

                  const SizedBox(height: 8),

                  // Typing indicator
                  ChatTypingIndicator(text: "$doctorName is typing..."),
                ],
              ),
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
                      child: const TextField(
                        decoration: InputDecoration(
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
                  Container(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
