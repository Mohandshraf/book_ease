import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/admin/data/quick_actions_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key, required this.quickActionModel});
  final QuickActionModel quickActionModel;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () {},
      child: Container(
        height: 120,
        width: 170,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.accentLilacLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                quickActionModel.icon,
                size: 22,
                color: AppColors.primary,
              ),
            ),
            const Gap(12),
            Text(
              quickActionModel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
