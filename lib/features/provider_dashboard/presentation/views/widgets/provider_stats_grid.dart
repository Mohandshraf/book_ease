import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProviderStatsGrid extends StatelessWidget {
  final ProviderDashboardStats stats;

  const ProviderStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: "Today's Appts",
                value: "${stats.todayAppointments}",
                icon: Icons.calendar_today_rounded,
                color: AppColors.accentSky,
                bgColor: AppColors.accentSkyLight,
              ),
            ),
            const Gap(14),
            Expanded(
              child: _StatCard(
                title: 'Pending Requests',
                value: "${stats.pendingRequests}",
                icon: Icons.pending_actions_rounded,
                color: AppColors.pending,
                bgColor: AppColors.pendingLight,
              ),
            ),
          ],
        ),
        const Gap(14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Confirmed',
                value: "${stats.confirmedBookings}",
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.primary,
                bgColor: AppColors.primaryLight,
              ),
            ),
            const Gap(14),
            Expanded(
              child: _StatCard(
                title: 'Earnings',
                value: "\$${stats.totalEarnings.toStringAsFixed(0)}",
                icon: Icons.attach_money_rounded,
                color: AppColors.success,
                bgColor: AppColors.successLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Gap(14),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const Gap(4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
