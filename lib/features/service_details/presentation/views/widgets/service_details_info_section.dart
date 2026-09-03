import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/widgets/safe_image.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ServiceDetailsInfoSection extends StatelessWidget {
  final ServiceDetailsModel model;

  const ServiceDetailsInfoSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Doctor Hero Row (Left: Rating, Name, Specialty, Price / Right: Doctor Portrait)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: .03),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentAmberLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.accentAmber,
                            size: 16,
                          ),
                          const Gap(4),
                          Text(
                            model.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Color(0xFFB45309),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(10),

                    // Doctor Name
                    Text(
                      model.providerName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                        height: 1.2,
                      ),
                    ),

                    const Gap(6),

                    // Specialty & Location
                    Text(
                      model.specialties.isNotEmpty
                          ? model.specialties.first
                          : model.title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Gap(2),

                    Text(
                      model.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Gap(12),

                    // Price Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${context.tr('details_from')} \$${model.price.toInt()} ${model.priceUnit}",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(14),

              // Right Doctor Portrait Photo
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SafeImage(
                  imageSource: model.imageUrl,
                  width: 125,
                  height: 155,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),

        const Gap(24),

        // About Doctor Section
        Text(
          context.tr('details_about_doctor'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),

        const Gap(8),

        Text(
          model.aboutText,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
