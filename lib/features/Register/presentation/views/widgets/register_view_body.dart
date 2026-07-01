import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/features/Register/presentation/views/widgets/custom_button.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:book_ease/features/login/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:book_ease/core/widgets/custom_text_field.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Form(
          key: formKey,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Account created successfully"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              }

              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
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
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.3),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),

                    const Gap(4),

                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const Gap(8),

                    Text(
                      "Join thousands of happy customers",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const Gap(34),

                    _buildLabel("FULL NAME"),

                    const Gap(10),

                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your name";
                        }

                        if (value.trim().length < 3) {
                          return "Name is too short";
                        }

                        return null;
                      },
                      controller: fullNameController,
                      hintText: "Alex Johnson",
                      prefixIcon: const Icon(Icons.person_outline),
                    ),

                    const Gap(24),

                    _buildLabel("EMAIL ADDRESS"),

                    const Gap(10),

                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }

                        final emailRegex = RegExp(
                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );

                        if (!emailRegex.hasMatch(value.trim())) {
                          return "Please enter a valid email";
                        }

                        return null;
                      },
                      controller: emailController,
                      hintText: "alex@email.com",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),

                    const Gap(24),

                    _buildLabel("PASSWORD"),

                    const Gap(10),

                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }

                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }

                        return null;
                      },
                      controller: passwordController,
                      hintText: "Min. 8 characters",
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),

                    const Gap(24),

                    _buildLabel("CONFIRM PASSWORD"),

                    const Gap(10),

                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm your password";
                        }

                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }

                        return null;
                      },
                      controller: confirmPasswordController,
                      hintText: "Repeat your password",
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),

                    const Gap(28),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.15,
                          child: Checkbox(
                            value: agree,
                            activeColor: AppColors.ksecondColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onChanged: (value) {
                              setState(() {
                                agree = value!;
                              });
                            },
                          ),
                        ),

                        const Gap(6),

                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                              ),
                              children: const [
                                TextSpan(text: "I agree to the "),
                                TextSpan(
                                  text: "Terms of Service",
                                  style: TextStyle(
                                    color: AppColors.ksecondColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: " and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: AppColors.ksecondColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Gap(34),

                    CustomButton(
                      text: state is AuthLoading
                          ? "Creating..."
                          : "Create Account",
                      onPressed: () {
                        if (!agree) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please accept Terms & Privacy Policy",
                              ),
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
                      color: Color(0xff0a947d),
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
      style: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: 1,
      ),
    );
  }
}
