import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_reset_helper.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_state.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/logout_button.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/menu_option_tile.dart';
import 'package:book_ease/features/provider_profile/presentation/views/widgets/credentials_dialog.dart';
import 'package:book_ease/features/provider_profile/presentation/views/widgets/provider_profile_header_card.dart';
import 'package:book_ease/features/settings/presentation/views/settings_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ProviderProfileViewBody extends StatelessWidget {
  const ProviderProfileViewBody({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.tr('profile_log_out_title'),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          context.tr('profile_log_out_confirm'),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.tr('common_cancel'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context, rootNavigator: true);
              final authCubit = context.read<AuthCubit>();

              Navigator.pop(dialogContext);

              AppResetHelper.resetAllUserData(context);

              try {
                await authCubit.signOut();
              } catch (_) {}

              navigator.pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              context.tr('profile_log_out'),
              style: const TextStyle(
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
    const Color iconColor = AppColors.primary;
    const Color iconBgColor = AppColors.primaryLight;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(36),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Provider Profile",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
                },
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const Gap(20),

          // Provider Profile Header Card
          const ProviderProfileHeaderCard(),

          const Gap(24),

          // Section Title: Professional Setup
          const Text(
            "Clinic & Practice",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(10),

          BlocBuilder<UserCubit, UserCubitState>(
            builder: (context, state) {
              final userData = state is UserDataLoaded
                  ? state.userData
                  : <String, dynamic>{};
              return Column(
                children: [
                  MenuOptionTile(
                    icon: Icons.person_pin_rounded,
                    title: "Personal Information",
                    subtitle: "Name, contact details, profile photo",
                    iconColor: iconColor,
                    iconBackgroundColor: iconBgColor,
                    onTap: () {
                      final user = FirebaseAuth.instance.currentUser;
                      Navigator.pushNamed(
                        context,
                        AppRoutes.editProfile,
                        arguments: {
                          'currentName':
                              userData['name'] ?? user?.displayName ?? '',
                          'currentEmail':
                              userData['email'] ?? user?.email ?? '',
                          'currentPhone': userData['phone'],
                          'currentPhotoUrl':
                              userData['photoUrl'] ?? user?.photoURL,
                        },
                      );
                    },
                  ),
                  MenuOptionTile(
                    icon: Icons.verified_user_outlined,
                    title: "Professional Credentials",
                    subtitle: "License, certifications, specialties",
                    iconColor: iconColor,
                    iconBackgroundColor: iconBgColor,
                    onTap: () => CredentialsDialog.show(context, userData),
                  ),
                  MenuOptionTile(
                    icon: Icons.access_time_filled_rounded,
                    title: "Working Hours & Availability",
                    subtitle: "Set working schedule and slots",
                    iconColor: iconColor,
                    iconBackgroundColor: iconBgColor,
                    onTap: () {
                      Navigator.pushNamed(
                          context, AppRoutes.providerAvailability);
                    },
                  ),
                ],
              );
            },
          ),

          const Gap(16),

          // Section Title: Account & Preferences
          const Text(
            "Preferences & Security",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(10),

          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, notifState) {
              final unreadCount =
                  notifState is NotificationLoaded ? notifState.unreadCount : 0;
              return MenuOptionTile(
                icon: Icons.notifications_none_rounded,
                title: "Booking Notifications",
                subtitle: "Alerts for new requests",
                iconColor: iconColor,
                iconBackgroundColor: iconBgColor,
                badgeCount: unreadCount,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
              );
            },
          ),
          MenuOptionTile(
            icon: Icons.lock_outline_rounded,
            title: "Security & Settings",
            subtitle: "Manage account and security",
            iconColor: iconColor,
            iconBackgroundColor: iconBgColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsView()),
              );
            },
          ),

          const Gap(16),

          // Logout Button
          LogoutButton(
            onTap: () => _showLogoutDialog(context),
          ),

          const Gap(100),
        ],
      ),
    );
  }
}
