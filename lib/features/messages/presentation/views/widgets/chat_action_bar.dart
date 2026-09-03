import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatActionBar extends StatelessWidget {
  final VoidCallback? onDetailsTap;
  final VoidCallback? onRescheduleTap;

  const ChatActionBar({
    super.key,
    this.onDetailsTap,
    this.onRescheduleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Button: Appointment details
        ScaleOnTap(
          onTap: onDetailsTap,
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.accentLilacLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.primary,
                  size: 16,
                ),
                const Gap(6),
                Text(
                  context.tr('chat_appointment_details'),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(10),
        // Button: Reschedule
        ScaleOnTap(
          onTap: onRescheduleTap,
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Center(
              child: Text(
                context.tr('chat_reschedule'),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

