import 'package:flutter/material.dart';

class DiscoverHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;

  const DiscoverHeader({
    super.key,
    required this.title,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBackTap ?? () => Navigator.maybePop(context),
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
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
          title,
          style: const TextStyle(
            color: Color(0xff0B1F44),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
