import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  final String doctorName;
  final VoidCallback? onBackTap;
  final VoidCallback? onCallTap;

  const ChatHeader({
    super.key,
    required this.doctorName,
    this.onBackTap,
    this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onBackTap ?? () => Navigator.maybePop(context),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xff0B1F44),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              doctorName,
              style: const TextStyle(
                color: Color(0xff0B1F44),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onCallTap,
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.phone_outlined,
              color: Color(0xff0B1F44),
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
