import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/admin/data/dashboard_state_model.dart';
import 'package:book_ease/features/admin/data/quick_actions_model.dart';
import 'package:book_ease/features/admin/data/recent_booking_model.dart';
import 'package:book_ease/features/admin/presentation/views/widgets/dashboard_state_card.dart';
import 'package:book_ease/features/admin/presentation/views/widgets/quick_actions_widget.dart';
import 'package:book_ease/features/admin/presentation/views/widgets/recent_bookings_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AdminViewBody extends StatelessWidget {
  const AdminViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.05,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return DashboardStatCard(model: dashboardStates[index]);
              },
              itemCount: dashboardStates.length,
            ),
            const Gap(24),
            const Text(
              "Quick Actions",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                itemCount: quickActions.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const Gap(12),
                itemBuilder: (context, index) {
                  return QuickActionsWidget(
                    quickActionModel: quickActions[index],
                  );
                },
              ),
            ),
            const Gap(24),
            RecentBookingsSection(bookings: recentBookings),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
