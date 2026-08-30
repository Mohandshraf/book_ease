import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProviderQuickActions extends StatelessWidget {
  final Function(int)? onTabChangeRequested;

  const ProviderQuickActions({super.key, this.onTabChangeRequested});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const Gap(14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ActionItem(
              icon: Icons.schedule_rounded,
              label: 'Availability',
              color: AppColors.accentLilac,
              bgColor: AppColors.accentLilacLight,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.providerAvailability);
              },
            ),
            _ActionItem(
              icon: Icons.medical_services_outlined,
              label: 'Services',
              color: AppColors.accentSky,
              bgColor: AppColors.accentSkyLight,
              onTap: () {
                onTabChangeRequested?.call(2); // Services tab
              },
            ),
            _ActionItem(
              icon: Icons.calendar_month_rounded,
              label: 'Bookings',
              color: AppColors.accentPeach,
              bgColor: AppColors.accentPeachLight,
              onTap: () {
                onTabChangeRequested?.call(1); // Bookings tab
              },
            ),
            _ActionItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Messages',
              color: AppColors.accentTeal,
              bgColor: AppColors.accentTealLight,
              onTap: () {
                onTabChangeRequested?.call(3); // Messages tab
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Gap(8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
