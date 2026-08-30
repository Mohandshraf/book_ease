import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_cubit.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_cubit.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_cubit.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/menu_option_tile.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "Log out",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to log out of your account?",
          style: TextStyle(color: AppColors.textSecondary, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ScaleOnTap(
            onTap: () async {
              debugPrint('LOGOUT DIALOG: Confirm clicked');
              final navigator = Navigator.of(context, rootNavigator: true);
              final userCubit = context.read<UserCubit>();
              final authCubit = context.read<AuthCubit>();
              final notifCubit = context.read<NotificationCubit>();
              final pBookingsCubit = context.read<ProviderBookingsCubit>();
              final pServicesCubit = context.read<ProviderServicesCubit>();
              final pDashboardCubit = context.read<ProviderDashboardCubit>();
              final chatCubit = context.read<ChatCubit>();

              Navigator.pop(dialogContext);

              try {
                userCubit.clearUserData();
                notifCubit.reset();
                pBookingsCubit.reset();
                pServicesCubit.reset();
                pDashboardCubit.reset();
                chatCubit.reset();
              } catch (e) {
                debugPrint('Error resetting cubits: $e');
              }

              try {
                await authCubit.signOut();
                debugPrint('LOGOUT DIALOG: Sign out complete');
              } catch (e) {
                debugPrint('Error signing out: $e');
              }

              debugPrint('LOGOUT DIALOG: Navigating to login...');
              navigator.pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cancelled,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cancelled.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                "Log out",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              ScaleOnTap(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Settings",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Settings List
          MenuOptionTile(
            icon: Icons.palette_outlined,
            title: "Appearance",
            subtitle: "System default",
            iconColor: AppColors.primary,
            iconBackgroundColor: AppColors.accentLilacLight,
            onTap: () {},
          ),
          MenuOptionTile(
            icon: Icons.language_rounded,
            title: "Language",
            subtitle: "English (US)",
            iconColor: const Color(0xff06B6D4),
            iconBackgroundColor: const Color(0xffECFEFF),
            onTap: () {},
          ),
          MenuOptionTile(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            subtitle: "Manage alerts",
            iconColor: const Color(0xffF59E0B),
            iconBackgroundColor: const Color(0xffFEF3C7),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
          MenuOptionTile(
            icon: Icons.shield_outlined,
            title: "Privacy",
            subtitle: "Data and permissions",
            iconColor: const Color(0xff10B981),
            iconBackgroundColor: const Color(0xffECFDF5),
            onTap: () {},
          ),
          MenuOptionTile(
            icon: Icons.lock_outline_rounded,
            title: "Security",
            subtitle: "Password and sign in",
            iconColor: const Color(0xff6366F1),
            iconBackgroundColor: const Color(0xffEEF2FF),
            onTap: () {},
          ),
          MenuOptionTile(
            icon: Icons.help_outline_rounded,
            title: "Help & Support",
            subtitle: "Support center",
            iconColor: const Color(0xffEC4899),
            iconBackgroundColor: const Color(0xffFDF2F8),
            onTap: () {},
          ),
          MenuOptionTile(
            icon: Icons.info_outline_rounded,
            title: "About",
            subtitle: "Version 2.4.1",
            iconColor: AppColors.textSecondary,
            iconBackgroundColor: AppColors.surfaceMuted,
            onTap: () {},
          ),

          // Log out Button
          LogoutButton(
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}

