import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_cubit.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ProviderServiceCard extends StatelessWidget {
  final ServiceModel service;
  final ValueChanged<ServiceModel> onEdit;
  final ValueChanged<ServiceModel> onDelete;

  const ProviderServiceCard({
    super.key,
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('cardio') || cat.contains('heart')) {
      return Icons.favorite_rounded;
    } else if (cat.contains('dent') || cat.contains('teeth')) {
      return Icons.health_and_safety_rounded;
    } else if (cat.contains('derm') || cat.contains('skin')) {
      return Icons.spa_rounded;
    } else if (cat.contains('neuro') || cat.contains('brain')) {
      return Icons.psychology_rounded;
    } else if (cat.contains('pediatric') || cat.contains('child')) {
      return Icons.child_care_rounded;
    } else if (cat.contains('ortho') || cat.contains('bone')) {
      return Icons.accessibility_new_rounded;
    } else if (cat.contains('psych') || cat.contains('mental')) {
      return Icons.mood_rounded;
    }
    return Icons.medical_services_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isActive = service.isActive;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isActive ? 1.0 : 0.72,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isActive
                ? AppColors.border.withValues(alpha: 0.8)
                : AppColors.border.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: isActive ? 0.04 : 0.01),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category Chip + Active Status Switch
            Row(
              children: [
                // Category Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(service.category),
                        size: 13,
                        color: AppColors.primary,
                      ),
                      const Gap(5),
                      Text(
                        service.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Active status pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? const Color(0xFF10B981)
                              : AppColors.textMuted,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        isActive ? 'Live' : 'Paused',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? const Color(0xFF059669)
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                // Toggle Switch
                SizedBox(
                  height: 24,
                  child: Transform.scale(
                    scale: 0.78,
                    child: Switch(
                      value: isActive,
                      activeThumbColor: AppColors.primary,
                      activeTrackColor: AppColors.primaryLight,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.borderLight,
                      onChanged: (val) {
                        if (service.id != null) {
                          context
                              .read<ProviderServicesCubit>()
                              .toggleActive(service.id!, service.isActive);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),

            // Title
            Text(
              service.title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
            if (service.description.isNotEmpty) ...[
              const Gap(4),
              Text(
                service.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
            const Gap(14),

            // Divider
            const Divider(height: 1, color: AppColors.borderLight),
            const Gap(12),

            // Bottom Row: Price, Duration & Action Buttons
            Row(
              children: [
                // Price
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$${service.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: ' ${service.priceUnit}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                // Duration Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const Gap(4),
                      Text(
                        '${service.durationMinutes} mins',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Edit Button
                ScaleOnTap(
                  onTap: () => onEdit(service),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.edit_outlined,
                        size: 17,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                // Delete Button
                ScaleOnTap(
                  onTap: () => onDelete(service),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.cancelledLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 17,
                        color: AppColors.cancelled,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

