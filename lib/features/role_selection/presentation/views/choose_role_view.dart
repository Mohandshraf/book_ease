import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ChooseRoleView extends StatelessWidget {
  const ChooseRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (state.userData != null) {
            context.read<UserCubit>().setUserData(state.userData!);
          }
          final role = state.userData?['role'];
          if (role == 'provider') {
            Navigator.pushReplacementNamed(context, AppRoutes.providerRoot);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.customerRoot);
          }
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(50),

                FadeSlideTransition(
                  delay: const Duration(milliseconds: 100),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentLight, width: 2),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 42,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const Gap(32),

                const FadeSlideTransition(
                  delay: Duration(milliseconds: 150),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to BookEase",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.8,
                        ),
                      ),
                      Gap(8),
                      Text(
                        "Choose how you want to use the app to continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(40),

                FadeSlideTransition(
                  delay: const Duration(milliseconds: 200),
                  child: _RoleCard(
                    icon: Icons.search_rounded,
                    iconBgColor: AppColors.accentLilacLight,
                    iconColor: AppColors.accentLilac,
                    badgeText: "Customer",
                    title: "Looking for Services",
                    subtitle: "Discover specialists & book appointments effortlessly",
                    onTap: () {
                      context.read<AuthCubit>().saveRole(role: "customer");
                    },
                  ),
                ),

                const Gap(18),

                FadeSlideTransition(
                  delay: const Duration(milliseconds: 250),
                  child: _RoleCard(
                    icon: Icons.business_center_outlined,
                    iconBgColor: AppColors.accentPeachLight,
                    iconColor: AppColors.accentPeach,
                    badgeText: "Provider",
                    title: "I Provide Services",
                    subtitle: "Manage schedule, track revenue & grow your business",
                    onTap: () {
                      context.read<AuthCubit>().saveRole(role: "provider");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.badgeText,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String badgeText;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),

            const Gap(16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(8),

            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryPale,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

