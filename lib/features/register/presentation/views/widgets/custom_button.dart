import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.gradient,
    this.height = 56,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Gradient? gradient;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: gradient == null ? (color ?? AppColors.primary) : null,
          gradient: gradient ??
              const LinearGradient(
                colors: [
                  AppColors.primaryGradientStart,
                  AppColors.primary,
                ],
              ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: (color ?? AppColors.primary).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 17,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}