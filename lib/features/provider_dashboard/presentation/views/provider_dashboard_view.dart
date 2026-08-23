import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/provider_dashboard/presentation/views/widgets/provider_dashboard_view_body.dart';
import 'package:flutter/material.dart';

class ProviderDashboardView extends StatelessWidget {
  final Function(int)? onTabChangeRequested;

  const ProviderDashboardView({super.key, this.onTabChangeRequested});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Provider Dashboard',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ProviderDashboardViewBody(
        onTabChangeRequested: onTabChangeRequested,
      ),
    );
  }
}
