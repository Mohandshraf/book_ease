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

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: service.isActive
                ? AppColors.border
                : AppColors.border.withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and Active Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentLilacLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    service.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      service.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: service.isActive
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                    ),
                    const Gap(6),
                    Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: service.isActive,
                        activeThumbColor: AppColors.primary,
                        activeTrackColor: AppColors.primaryLight,
                        onChanged: (val) {
                          if (service.id != null) {
                            context
                                .read<ProviderServicesCubit>()
                                .toggleActive(service.id!, service.isActive);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(10),

            // Title
            Text(
              service.title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: service.isActive
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            if (service.description.isNotEmpty) ...[
              const Gap(6),
              Text(
                service.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
            const Divider(height: 28, color: AppColors.border),

            // Price, Duration, and Actions
            Row(
              children: [
                Text(
                  '\$${service.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  ' ${service.priceUnit}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Gap(14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
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
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ScaleOnTap(
                  onTap: () => onEdit(service),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                  ),
                ),
                const Gap(8),
                ScaleOnTap(
                  onTap: () => onDelete(service),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cancelledLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.cancelled),
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
