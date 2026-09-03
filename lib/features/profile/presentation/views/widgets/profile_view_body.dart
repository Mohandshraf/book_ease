import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/utils/app_reset_helper.dart';
import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_state.dart';
import 'package:book_ease/features/profile/presentation/views/edit_profile_view.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/logout_button.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/menu_option_tile.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/profile_card.dart';
import 'package:book_ease/features/root/presentation/views/customer_root_view.dart';
import 'package:book_ease/features/settings/presentation/views/settings_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  @override
  void initState() {
    super.initState();
    final userCubitState = context.read<UserCubit>().state;
    if (userCubitState is! UserDataLoaded) {
      context.read<UserCubit>().getCurrentUserData();
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          context.tr('profile_log_out_title'),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          context.tr('profile_log_out_confirm'),
          style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          ScaleOnTap(
            onTap: () async {
              debugPrint('CUSTOMER LOGOUT: Confirm clicked');
              final navigator = Navigator.of(context, rootNavigator: true);
              final authCubit = context.read<AuthCubit>();

              Navigator.pop(dialogContext);

              AppResetHelper.resetAllUserData(context);

              try {
                await authCubit.signOut();
                debugPrint('CUSTOMER LOGOUT: Sign out complete');
              } catch (e) {
                debugPrint('Error signing out: $e');
              }

              debugPrint('CUSTOMER LOGOUT: Navigating to login...');
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
              child: Text(
                context.tr('profile_log_out'),
                style: const TextStyle(
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
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('profile_title'),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ScaleOnTap(
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
                        color: AppColors.shadowColor.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
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
          const SizedBox(height: 24),

          // Reactive Profile Card linked to UserCubit & Firebase
          BlocBuilder<UserCubit, UserCubitState>(
            builder: (context, state) {
              final currentUser = FirebaseAuth.instance.currentUser;
              String name = currentUser?.displayName ?? "User";
              String email = currentUser?.email ?? "";
              String? photoUrl = currentUser?.photoURL;
              String? phone = currentUser?.phoneNumber;

              if (state is UserDataLoaded) {
                name = (state.userData['name'] as String?)?.trim().isNotEmpty == true
                    ? state.userData['name']
                    : name;
                email = (state.userData['email'] as String?)?.trim().isNotEmpty == true
                    ? state.userData['email']
                    : email;
                photoUrl = (state.userData['photoUrl'] as String?)?.isNotEmpty == true
                    ? state.userData['photoUrl']
                    : photoUrl;
                phone = (state.userData['phone'] as String?)?.isNotEmpty == true
                    ? state.userData['phone']
                    : phone;
              }

              return ProfileCard(
                name: name,
                email: email,
                imageUrl: photoUrl,
                onEditTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileView(
                        currentName: name,
                        currentEmail: email,
                        currentPhotoUrl: photoUrl,
                        currentPhone: phone,
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Menu Options
          MenuOptionTile(
            icon: Icons.calendar_month_outlined,
            title: context.tr('profile_appointments'),
            iconColor: AppColors.primary,
            iconBackgroundColor: AppColors.accentLilacLight,
            onTap: () {
              CustomerRootView.navigateToTab(context, 2);
            },
          ),
          MenuOptionTile(
            icon: Icons.favorite_outline_rounded,
            title: context.tr('profile_saved_providers'),
            iconColor: const Color(0xffEC4899),
            iconBackgroundColor: const Color(0xffFDF2F8),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.savedProviders);
            },
          ),
          MenuOptionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: context.tr('profile_messages'),
            iconColor: const Color(0xff06B6D4),
            iconBackgroundColor: const Color(0xffECFEFF),
            onTap: () {
              CustomerRootView.navigateToTab(context, 3);
            },
          ),
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, notifState) {
              final unreadCount =
                  notifState is NotificationLoaded ? notifState.unreadCount : 0;
              return MenuOptionTile(
                icon: Icons.notifications_none_rounded,
                title: context.tr('profile_notifications'),
                iconColor: const Color(0xffF59E0B),
                iconBackgroundColor: const Color(0xffFEF3C7),
                badgeCount: unreadCount,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
              );
            },
          ),

          // Log out Button
          LogoutButton(
            onTap: () => _showLogoutDialog(context),
          ),
          const Gap(100),
        ],
      ),
    );
  }
}
