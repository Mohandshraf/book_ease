import 'package:book_ease/features/messages/presentation/views/widgets/chat_view_body.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  final String doctorName;

  const ChatView({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: ChatViewBody(doctorName: doctorName),
    );
  }
}
