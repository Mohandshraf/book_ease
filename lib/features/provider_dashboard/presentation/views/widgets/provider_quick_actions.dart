import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ActionItem(
              icon: Icons.schedule_rounded,
              label: 'Availability',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.providerAvailability);
              },
            ),
            _ActionItem(
              icon: Icons.medical_services_outlined,
              label: 'Services',
              onTap: () {
                onTabChangeRequested?.call(2); // Services tab
              },
            ),
            _ActionItem(
              icon: Icons.calendar_month_rounded,
              label: 'Bookings',
              onTap: () {
                onTabChangeRequested?.call(1); // Bookings tab
              },
            ),
            _ActionItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Messages',
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
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
