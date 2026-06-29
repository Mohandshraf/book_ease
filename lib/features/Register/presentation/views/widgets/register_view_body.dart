import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/features/Register/presentation/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:book_ease/core/widgets/custom_text_field.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.3),
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
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
              ),

              const Gap(8),

              Text(
                "Join thousands of happy customers",
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),

              const Gap(34),

              _buildLabel("FULL NAME"),

              const Gap(10),

              CustomTextField(
                controller: fullNameController,
                hintText: "Alex Johnson",
                prefixIcon: const Icon(Icons.person_outline),
              ),

              const Gap(24),

              _buildLabel("EMAIL ADDRESS"),

              const Gap(10),

              CustomTextField(
                controller: emailController,
                hintText: "alex@email.com",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail_outline),
              ),

              const Gap(24),

              _buildLabel("PASSWORD"),

              const Gap(10),

              CustomTextField(
                controller: passwordController,
                hintText: "Min. 8 characters",
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline),
              ),

              const Gap(24),

              _buildLabel("CONFIRM PASSWORD"),

              const Gap(10),

              CustomTextField(
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
                text: "Create Account",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Register
                  }
                },
                color: Color(0xff0a947d),
              ),

              const Gap(24),
            ],
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
