import 'dart:convert';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 36,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primaryLight;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      final img = imageUrl!.trim();

      // Check if Base64
      if (img.startsWith('data:image') || img.length > 500) {
        try {
          final base64Clean =
              img.contains(',') ? img.split(',').last : img;
          final bytes = base64Decode(base64Clean);
          return CircleAvatar(
            radius: radius,
            backgroundColor: bg,
            backgroundImage: MemoryImage(bytes),
          );
        } catch (_) {}
      }

      // Check if Network URL
      if (img.startsWith('http://') || img.startsWith('https://')) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: bg,
          backgroundImage: NetworkImage(img),
          onBackgroundImageError: (e, s) {},
        );
      }
    }

    // Fallback: Initials or Icon
    final initial = (name != null && name!.trim().isNotEmpty)
        ? name!.trim()[0].toUpperCase()
        : null;

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: initial != null
          ? Text(
              initial,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: radius * 0.8,
                fontWeight: FontWeight.bold,
              ),
            )
          : Icon(
              Icons.person_rounded,
              color: AppColors.accent,
              size: radius * 0.9,
            ),
    );
  }
}
