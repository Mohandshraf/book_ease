import 'package:book_ease/features/auth/data/UserCubit/cubit/user_cubit_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/login/presentation/views/login_view.dart';
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
              Navigator.pop(dialogContext);
              await context.read<AuthCubit>().signOut();
              if (context.mounted) {
                context.read<UserCubit>().clearUserData();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (route) => false,
                );
              }
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

