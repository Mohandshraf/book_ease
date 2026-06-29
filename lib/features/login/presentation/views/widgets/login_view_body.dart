import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/core/widgets/custom_text_field.dart';

import 'package:book_ease/features/Register/presentation/views/register_view.dart';
import 'package:book_ease/features/login/presentation/views/widgets/selection_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),

            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xffDDFBF0),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Image.asset("assets/images/calender.png"),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Welcome back",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: Color(0xff0B1F44),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Sign in to your BookEase account",
              style: TextStyle(fontSize: 18, color: Color(0xff6F7F95)),
            ),

            const SizedBox(height: 45),

            const Text(
              "EMAIL ADDRESS",
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                color: Color(0xff8A9AB0),
              ),
            ),

            const SizedBox(height: 10),

            CustomTextField(
              fillColor: const Color(0xffF7FAFC),
              hintText: "Email Address",
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Color(0xff93A2B8),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "PASSWORD",
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                color: Color(0xff8A9AB0),
              ),
            ),

            const SizedBox(height: 10),

            CustomTextField(
              fillColor: const Color(0xffF7FAFC),
              hintText: "Password",
              obscureText: true,
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xff93A2B8),
              ),
              suffixIcon: const Icon(
                Icons.visibility_outlined,
                color: Color(0xff93A2B8),
              ),
            ),

            const SizedBox(height: 18),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Color(0xff0B9B7B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0B9B7B),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: Container(height: 1, color: const Color(0xffE2E8F0)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or continue with',
                    style: TextStyle(color: Color(0xff94A3B8), fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(height: 1, color: const Color(0xffE2E8F0)),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: SocialButton(
                    title: 'Google',
                    icon: 'assets/images/google.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SocialButton(
                    title: 'Apple',
                    icon: 'assets/images/apple.png',
                  ),
                ),
              ],
            ),
            Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegisterView();
                      },
                    ),
                  ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.ksecondColor,
                      fontSize: 18,
                    ),
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
