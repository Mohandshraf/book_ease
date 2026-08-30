import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/utils/validators.dart';
import 'package:book_ease/core/widgets/custom_text_field.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:book_ease/features/register/presentation/views/widgets/custom_button.dart';
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
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: formKey,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 50),
                      child: ScaleOnTap(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border, width: 1.2),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    const Gap(24),

                    const FadeSlideTransition(
                      delay: Duration(milliseconds: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.8,
                            ),
                          ),
                          Gap(8),
                          Text(
                            "Join thousands of happy BookEase members",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(32),

                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 150),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("FULL NAME"),
                          const Gap(8),
                          CustomTextField(
                            validator: (value) => Validators.name(value),
                            controller: fullNameController,
                            hintText: "Alex Johnson",
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                          ),
                          const Gap(20),
                          _buildLabel("EMAIL ADDRESS"),
                          const Gap(8),
                          CustomTextField(
                            validator: (value) => Validators.email(value),
                            controller: emailController,
                            hintText: "alex@email.com",
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(
                              Icons.mail_outline,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                          ),
                          const Gap(20),
                          _buildLabel("PASSWORD"),
                          const Gap(8),
                          CustomTextField(
                            validator: (value) => Validators.password(value),
                            controller: passwordController,
                            hintText: "Min. 8 characters",
                            obscureText: isPasswordObscure,
                            prefixIcon: const Icon(
                              Icons.lock_outline,
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
                          const Gap(20),
                          _buildLabel("CONFIRM PASSWORD"),
                          const Gap(8),
                          CustomTextField(
                            validator: (value) => Validators.confirmPassword(
                              value,
                              passwordController.text,
                            ),
                            controller: confirmPasswordController,
                            hintText: "Repeat your password",
                            obscureText: isConfirmPasswordObscure,
                            prefixIcon: const Icon(
                              Icons.lock_outline,
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
                        ],
                      ),
                    ),

                    const Gap(24),

                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 200),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: agree,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              side: const BorderSide(color: AppColors.border, width: 1.5),
                              onChanged: (value) {
                                setState(() {
                                  agree = value ?? false;
                                });
                              },
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(text: "I agree to the "),
                                  TextSpan(
                                    text: "Terms of Service",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(28),

                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 250),
                      child: CustomButton(
                        text: state is AuthLoading
                            ? "Creating account..."
                            : "Create Account",
                        onPressed: () {
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
                      ),
                    ),

                    const Gap(24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.8,
      ),
    );
  }
}

