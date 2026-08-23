import 'package:book_ease/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProviderServicesSummaryBanner extends StatelessWidget {
  final int activeCount;
  final int totalCount;
  final VoidCallback onAddNew;

  const ProviderServicesSummaryBanner({
    super.key,
    required this.activeCount,
    required this.totalCount,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.medical_services_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '$activeCount Active of $totalCount Total Services',
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onAddNew,
            child: const Text(
              '+ New',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
