import 'package:book_ease/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProviderServicesSummaryBanner extends StatelessWidget {
  final int activeCount;
  final int totalCount;

  const ProviderServicesSummaryBanner({
    super.key,
    required this.activeCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveCount = totalCount - activeCount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Stat 1: Total Services
          Expanded(
            child: _buildMetricTile(
              icon: Icons.layers_outlined,
              iconColor: AppColors.primary,
              iconBg: AppColors.primaryLight,
              title: 'Total Services',
              value: '$totalCount',
            ),
          ),
          Container(
            height: 36,
            width: 1,
            color: AppColors.borderLight,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          // Stat 2: Active Services
          Expanded(
            child: _buildMetricTile(
              icon: Icons.check_circle_outline_rounded,
              iconColor: const Color(0xFF10B981),
              iconBg: const Color(0xFFECFDF5),
              title: 'Active & Live',
              value: '$activeCount',
            ),
          ),
          if (inactiveCount > 0) ...[
            Container(
              height: 36,
              width: 1,
              color: AppColors.borderLight,
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            // Stat 3: Paused / Inactive
            Expanded(
              child: _buildMetricTile(
                icon: Icons.pause_circle_outline_rounded,
                iconColor: const Color(0xFFF59E0B),
                iconBg: const Color(0xFFFEF3C7),
                title: 'Paused',
                value: '$inactiveCount',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

