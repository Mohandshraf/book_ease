import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/widgets/safe_image.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingSummaryClinicCard extends StatelessWidget {
  final ServiceDetailsModel model;

  const BookingSummaryClinicCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: .04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SafeImage(
              imageSource: model.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Gap(4),
                Text(
                  model.providerName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                Row(
                  children: const [
                    Icon(Icons.star_rounded, color: AppColors.rating, size: 16),
                    Icon(Icons.star_rounded, color: AppColors.rating, size: 16),
                    Icon(Icons.star_rounded, color: AppColors.rating, size: 16),
                    Icon(Icons.star_rounded, color: AppColors.rating, size: 16),
                    Icon(Icons.star_rounded, color: AppColors.rating, size: 16),
                    Gap(4),
                    Text(
                      "(284)",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
