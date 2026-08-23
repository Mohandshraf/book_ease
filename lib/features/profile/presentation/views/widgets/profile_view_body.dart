import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/messages/presentation/views/messages_view.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/profile/presentation/views/edit_profile_view.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/logout_button.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/menu_option_tile.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/profile_card.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_cubit.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_cubit.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_cubit.dart';
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
              debugPrint('CUSTOMER LOGOUT: Confirm clicked');
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Profile",
                style: TextStyle(
                  color: Color(0xff0B1F44),
                  fontSize: 28,
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
                    Icons.settings_outlined,
                    color: Color(0xff0B1F44),
                    size: 22,
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
            title: "My bookings",
            iconColor: const Color(0xff0B9B7B),
            iconBackgroundColor: const Color(0xffEAFDF6),
            onTap: () {
              // Action or navigation
            },
          ),
          MenuOptionTile(
            icon: Icons.favorite_outline_rounded,
            title: "Saved providers",
            iconColor: const Color(0xff0B9B7B),
            iconBackgroundColor: const Color(0xffEAFDF6),
            onTap: () {
              // Action
            },
          ),
          MenuOptionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: "Messages",
            iconColor: const Color(0xff0B9B7B),
            iconBackgroundColor: const Color(0xffEAFDF6),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagesView(),
                ),
              );
            },
          ),
          MenuOptionTile(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            iconColor: const Color(0xff0B9B7B),
            iconBackgroundColor: const Color(0xffEAFDF6),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
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
