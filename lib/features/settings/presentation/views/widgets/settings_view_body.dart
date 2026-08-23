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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Log out",
          style: TextStyle(
            color: Color(0xff0B1F44),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to log out of your account?",
          style: TextStyle(color: Color(0xff64748B)),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Color(0xff64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF3B30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Log out",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color iconColor = Color(0xff64748B);
    const Color iconBgColor = Color(0xffF1F5F9);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xff0B1F44),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Settings",
                style: TextStyle(
                  color: Color(0xff0B1F44),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Settings List
          MenuOptionTile(
            icon: Icons.remove_red_eye_outlined,
            title: "Appearance",
            subtitle: "System default",
            iconColor: iconColor,
            iconBackgroundColor: iconBgColor,
            onTap: () {
              // Action
            },
          ),
          MenuOptionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: "Language",
            subtitle: "English (US)",
            iconColor: iconColor,
            iconBackgroundColor: iconBgColor,
            onTap: () {
              // Action
            },
          ),
          MenuOptionTile(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            subtitle: "Manage alerts",
            iconColor: iconColor,
            iconBackgroundColor: iconBgColor,
            onTap: () {
              // Action
            },
          ),
          MenuOptionTile(
            icon: Icons.shield_outlined,
            title: "Privacy",
            subtitle: "Data and permissions",
            iconColor: iconColor,
            iconBackgroundColor: iconBgColor,
            onTap: () {
              // Action
            },
          ),
          MenuOptionTile(
            icon: Icons.lock_outline_rounded,
            title: "Security",
            subtitle: "Password and sign in",
            iconColor: iconColor,
            iconBackgroundColor: iconBgColor,
            onTap: () {
              // Action
            },
          ),
          MenuOptionTile(
            icon: Icons.phone_outlined,
            title: "Help",
            subtitle: "Support center",
            iconColor: iconColor,
            iconBackgroundColor: iconBgColor,
            onTap: () {
              // Action
            },
          ),
          MenuOptionTile(
            icon: Icons.more_horiz_rounded,
            title: "About",
            subtitle: "Version 2.4.1",
            iconColor: iconColor,
            iconBackgroundColor: iconBgColor,
            onTap: () {
              // Action
            },
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

