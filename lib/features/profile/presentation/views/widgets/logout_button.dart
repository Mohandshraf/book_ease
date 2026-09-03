import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.cancelledLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cancelled.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cancelled.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ScaleOnTap(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // White circle with red arrow
                Container(
                  height: 44,
                  width: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    context.isRtl
                        ? Icons.logout_rounded
                        : Icons.logout_rounded,
                    color: AppColors.cancelled,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                // Text
                Text(
                  context.tr('profile_log_out'),
                  style: const TextStyle(
                    color: AppColors.cancelled,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
