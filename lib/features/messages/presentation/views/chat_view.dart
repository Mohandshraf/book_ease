import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/messages/presentation/views/widgets/chat_view_body.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  final String otherUserId;
  final String doctorName;
  final String? otherUserImage;
  final String? otherUserSpecialty;

  const ChatView({
    super.key,
    required this.otherUserId,
    required this.doctorName,
    this.otherUserImage,
    this.otherUserSpecialty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ChatViewBody(
        otherUserId: otherUserId,
        doctorName: doctorName,
        otherUserImage: otherUserImage,
        otherUserSpecialty: otherUserSpecialty,
      ),
    );
  }
}
