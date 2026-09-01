import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ChooseRoleView extends StatefulWidget {
  const ChooseRoleView({super.key});

  @override
  State<ChooseRoleView> createState() => _ChooseRoleViewState();
}

class _ChooseRoleViewState extends State<ChooseRoleView> {
  String selectedRole = 'customer'; // 'customer' or 'provider'

  void _onContinue() {
    // Save role in AuthCubit
    context.read<AuthCubit>().saveRole(role: selectedRole);

    // Also directly handle navigation transition smoothly
    if (selectedRole == 'provider') {
      Navigator.pushReplacementNamed(context, AppRoutes.providerRoot);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.customerRoot);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (state.userData != null) {
            context.read<UserCubit>().setUserData(state.userData!);
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Bar with Back Arrow, Moon Theme & Close (X) Icon
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          }
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.dark_mode_outlined,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          const Gap(8),
                          GestureDetector(
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacementNamed(context, AppRoutes.onBoarding);
                              }
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceMuted,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Gap(18),

                // Header Title & Subtitle (Exact Match to Reference Screenshot)
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 150),
                  child: Column(
                    children: const [
                      Text(
                        "Select Role",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.6,
                        ),
                      ),
                      Gap(4),
                      Text(
                        "Are you booking an appointment or offering services?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Two Side-by-Side Role Cards (Exact 2-Column Grid Layout)
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      // Left Card: Patient / Customer
                      Expanded(
                        child: _RoleSelectCard(
                          isSelected: selectedRole == 'customer',
                          onTap: () {
                            setState(() {
                              selectedRole = 'customer';
                            });
                          },
                          iconWidget: CustomPaint(
                            size: const Size(36, 36),
                            painter: ConcentricTargetPainter(
                              color: selectedRole == 'customer'
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                            ),
                          ),
                          title: "I need a Doctor",
                          tag: "(Patient)",
                          subLabel: "LOOKING FOR CARE",
                        ),
                      ),

                      const Gap(14),

                      // Right Card: Doctor / Provider
                      Expanded(
                        child: _RoleSelectCard(
                          isSelected: selectedRole == 'provider',
                          onTap: () {
                            setState(() {
                              selectedRole = 'provider';
                            });
                          },
                          iconWidget: Icon(
                            Icons.medical_services_outlined,
                            size: 32,
                            color: selectedRole == 'provider'
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                          title: "I am Offering",
                          tag: "(Doctor / Clinic)",
                          subLabel: "PROVIDING SERVICES",
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom Section: Support Help Pill + Continue Button + Login Link
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 250),
                  child: Column(
                    children: [
                      // Help Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.attach_file_rounded,
                                  size: 16,
                                  color: AppColors.textMuted,
                                ),
                                Gap(8),
                                Text(
                                  "Need help choosing role?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Connecting to BookEase Support..."),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    "Ask Support",
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Gap(2),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 12,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Gap(14),

                      // Continue Primary Button
                      ScaleOnTap(
                        onTap: _onContinue,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.28),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Gap(8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Gap(14),

                      // Footer: Already have an account? Log In
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Gap(10),
                    ],
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

class _RoleSelectCard extends StatelessWidget {
  const _RoleSelectCard({
    required this.isSelected,
    required this.onTap,
    required this.iconWidget,
    required this.title,
    required this.tag,
    required this.subLabel,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget iconWidget;
  final String title;
  final String tag;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 26),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2.2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.14)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Checkmark Badge at Top Right
            Positioned(
              top: -14,
              right: -4,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isSelected
                      ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                      : const SizedBox.shrink(),
                ),
              ),
            ),

            // Card Body Content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Badge in Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFDBEAFE) : AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.border,
                    ),
                  ),
                  child: Center(child: iconWidget),
                ),

                const Gap(16),

                // Title & Role Tag
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const Gap(2),
                Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),

                const Gap(10),

                // Sub-label (ALL CAPS TRACKED)
                Text(
                  subLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConcentricTargetPainter extends CustomPainter {
  final Color color;
  const ConcentricTargetPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Outer thin ring (opacity 0.35)
    final outerPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawCircle(center, size.width * 0.44, outerPaint);

    // Middle ring
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawCircle(center, size.width * 0.28, strokePaint);

    // Center filled circle
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.12, fillPaint);
  }

  @override
  bool shouldRepaint(covariant ConcentricTargetPainter oldDelegate) =>
      oldDelegate.color != color;
}
