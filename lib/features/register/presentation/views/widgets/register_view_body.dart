import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/utils/app_reset_helper.dart';
import 'package:book_ease/core/utils/validators.dart';
import 'package:book_ease/core/widgets/custom_text_field.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  bool isUsingMobile = false;
  bool agree = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AppResetHelper.resetAllUserData(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Account created successfully. Please sign in."),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );

            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
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

                      // Header Title & Subtitle (Exact Match to HTML Prototype)
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                letterSpacing: -0.6,
                              ),
                            ),
                            Gap(4),
                            Text(
                              "Sign up to get started!",
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
                            // Full Name
                            const Text(
                              "Full Name",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Gap(8),
                            CustomTextField(
                              validator: (value) => Validators.name(value),
                              controller: fullNameController,
                              hintText: "Enter full name",
                              prefixIcon: const Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),

                            const Gap(16),

                            // Email Address with Mobile Switcher
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

                            // Password
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
                              validator: (value) => Validators.password(value),
                              controller: passwordController,
                              hintText: "Enter password",
                              obscureText: isPasswordObscure,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordObscure = !isPasswordObscure;
                                  });
                                },
                              ),
                            ),

                            const Gap(16),

                            // Confirm Password
                            const Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const Gap(8),

                            CustomTextField(
                              validator: (value) => Validators.confirmPassword(
                                value,
                                passwordController.text,
                              ),
                              controller: confirmPasswordController,
                              hintText: "Confirm password",
                              obscureText: isConfirmPasswordObscure,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordObscure = !isConfirmPasswordObscure;
                                  });
                                },
                              ),
                            ),

                            const Gap(14),

                            // Terms and Privacy Checkbox
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: agree,
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        agree = val ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const Gap(8),
                                const Expanded(
                                  child: Text(
                                    "I agree to the Terms of Service & Privacy Policy",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Gap(22),

                      // Primary Sign Up Button
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 250),
                        child: ScaleOnTap(
                          onTap: () {
                            if (!agree) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please accept Terms & Privacy Policy",
                                  ),
                                  backgroundColor: AppColors.warning,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().register(
                                name: fullNameController.text.trim(),
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
                            child: Center(
                              child: Text(
                                state is AuthLoading ? "Creating account..." : "Sign Up",
                                style: const TextStyle(
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

                      // Divider: — or sign up with —
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
                                "— or sign up with —",
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

                      // Circular Social Buttons Row (Exact Match to HTML Prototype)
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 350),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SocialCircularButton(
                              iconWidget: Image.asset(
                                "assets/images/google.png",
                                width: 20,
                                height: 20,
                              ),
                              onTap: () {
                                context.read<AuthCubit>().signInWithGoogle();
                              },
                            ),
                            const Gap(16),
                            _SocialCircularButton(
                              iconWidget: Image.asset(
                                "assets/images/apple.png",
                                width: 20,
                                height: 20,
                              ),
                              onTap: () {},
                            ),
                            const Gap(16),
                            _SocialCircularButton(
                              iconWidget: const Icon(
                                Icons.facebook,
                                color: Color(0xFF1877F2),
                                size: 24,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const Gap(24),

                      // Footer: Already have an account? Log In
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 400),
                        child: Row(
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

class _SocialCircularButton extends StatelessWidget {
  const _SocialCircularButton({
    required this.iconWidget,
    required this.onTap,
  });

  final Widget iconWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(child: iconWidget),
      ),
    );
  }
}
