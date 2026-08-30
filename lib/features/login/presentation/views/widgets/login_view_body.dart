import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/utils/validators.dart';
import 'package:book_ease/core/widgets/custom_text_field.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/login/presentation/views/widgets/selection_button.dart';
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
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
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

            if (state.hasRole) {
              if (state.userData != null) {
                context.read<UserCubit>().setUserData(state.userData!);
              }
              final role = state.userData?['role'];
              if (role == 'provider') {
                Navigator.pushReplacementNamed(context, AppRoutes.providerRoot);
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.customerRoot);
              }
            } else {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(60),

                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 100),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.accentLight, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset("assets/images/calender.png"),
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
                            "Welcome back",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.8,
                            ),
                          ),
                          Gap(8),
                          Text(
                            "Sign in to your BookEase account",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(36),

                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "EMAIL ADDRESS",
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const Gap(8),
                          CustomTextField(
                            validator: (value) => Validators.email(value),
                            controller: emailcontroller,
                            hintText: "Enter your email",
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                          ),
                          const Gap(20),
                          const Text(
                            "PASSWORD",
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const Gap(8),
                          CustomTextField(
                            controller: passwordcontroller,
                            hintText: "Enter your password",
                            obscureText: isObscure,
                            prefixIcon: const Icon(
                              Icons.lock_outline,
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
                          const Gap(12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(16),

                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 250),
                      child: ScaleOnTap(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthCubit>().signIn(
                              email: emailcontroller.text.trim(),
                              password: passwordcontroller.text.trim(),
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryGradientStart,
                                AppColors.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Gap(28),

                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.border,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  'or continue with',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.border,
                                ),
                              ),
                            ],
                          ),
                          const Gap(24),
                          Row(
                            children: [
                              Expanded(
                                child: SocialButton(
                                  title: 'Google',
                                  icon: 'assets/images/google.png',
                                  onTap: () {
                                    context.read<AuthCubit>().signInWithGoogle();
                                  },
                                ),
                              ),
                              const Gap(14),
                              const Expanded(
                                child: SocialButton(
                                  title: 'Apple',
                                  icon: 'assets/images/apple.png',
                                ),
                              ),
                            ],
                          ),
                          const Gap(32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                ),
                              ),
                              ScaleOnTap(
                                onTap: () =>
                                    Navigator.pushNamed(context, AppRoutes.register),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.0,
                                    vertical: 4.0,
                                  ),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Gap(30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

