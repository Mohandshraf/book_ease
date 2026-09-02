import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/utils/validators.dart';
import 'package:book_ease/core/widgets/custom_text_field.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isObscure = true;
  bool isUsingMobile = false;
  bool keepMeLoggedIn = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Signed in successfully"),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );

            if (state.userData != null) {
              context.read<UserCubit>().setUserData(state.userData!);
            }

            // Check if user already has a saved role
            final role = state.userData?['role'];
            if (role == 'provider') {
              Navigator.pushReplacementNamed(context, AppRoutes.providerRoot);
            } else if (role == 'customer') {
              Navigator.pushReplacementNamed(context, AppRoutes.customerRoot);
            } else if (role == 'admin') {
              Navigator.pushReplacementNamed(context, AppRoutes.admin);
            } else {
              // Only prompt role selection if user has never selected a role
              Navigator.pushReplacementNamed(context, AppRoutes.chooseRole);
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
        builder: (context, state) {
          return Skeletonizer(
            enabled: state is AuthLoading,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar with Back Arrow & Theme Moon Icon
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
                                  Navigator.pushReplacementNamed(context, AppRoutes.onBoarding);
                                }
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
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
                          ],
                        ),
                      ),

                      const Gap(24),

                      // Header Title & Subtitle (Exact match to HTML prototype)
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Login Account",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                letterSpacing: -0.6,
                              ),
                            ),
                            Gap(4),
                            Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Gap(24),

                      // Form Fields
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email/Mobile label with switcher
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isUsingMobile ? "Mobile Number" : "Email Address",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isUsingMobile = !isUsingMobile;
                                    });
                                  },
                                  child: Text(
                                    isUsingMobile ? "Email Address?" : "Mobile Number?",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Gap(8),

                            CustomTextField(
                              validator: (value) => isUsingMobile
                                  ? Validators.phone(value)
                                  : Validators.email(value),
                              controller: emailController,
                              hintText: isUsingMobile
                                  ? "Enter mobile number"
                                  : "Enter email address",
                              keyboardType: isUsingMobile
                                  ? TextInputType.phone
                                  : TextInputType.emailAddress,
                              prefixIcon: Icon(
                                isUsingMobile
                                    ? Icons.phone_android_rounded
                                    : Icons.email_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),

                            const Gap(16),

                            // Password label
                            const Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const Gap(8),

                            CustomTextField(
                              controller: passwordController,
                              validator: (value) => Validators.password(value),
                              hintText: "Enter password",
                              obscureText: isObscure,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                              ),
                            ),

                            const Gap(8),

                            // Keep me logged in & Forgot password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: keepMeLoggedIn,
                                        activeColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            keepMeLoggedIn = val ?? true;
                                          });
                                        },
                                      ),
                                    ),
                                    const Gap(6),
                                    const Text(
                                      "Keep me logged in",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Gap(22),

                      // Primary Login Button
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 250),
                        child: ScaleOnTap(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            }
                          },
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
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Gap(22),

                      // Divider: — or sign in with —
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 300),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(height: 1, color: AppColors.border),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                "— or sign in with —",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(height: 1, color: AppColors.border),
                            ),
                          ],
                        ),
                      ),

                      const Gap(18),

                      // Stacked Full-Width Social Buttons (Exact Match to Reference HTML)
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 350),
                        child: Column(
                          children: [
                            _SocialLoginPillButton(
                              iconWidget: Image.asset(
                                "assets/images/google.png",
                                width: 20,
                                height: 20,
                              ),
                              label: "Continue With Google",
                              onTap: () {
                                context.read<AuthCubit>().signInWithGoogle();
                              },
                            ),
                            const Gap(10),
                            _SocialLoginPillButton(
                              iconWidget: Image.asset(
                                "assets/images/apple.png",
                                width: 20,
                                height: 20,
                              ),
                              label: "Continue With Apple",
                              onTap: () {},
                            ),
                            const Gap(10),
                            _SocialLoginPillButton(
                              iconWidget: const Icon(
                                Icons.facebook,
                                color: Color(0xFF1877F2),
                                size: 22,
                              ),
                              label: "Continue With Facebook",
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const Gap(24),

                      // Footer: Don't have an account? Sign Up
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 400),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.register);
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Gap(16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SocialLoginPillButton extends StatelessWidget {
  const _SocialLoginPillButton({
    required this.iconWidget,
    required this.label,
    required this.onTap,
  });

  final Widget iconWidget;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const Gap(10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
