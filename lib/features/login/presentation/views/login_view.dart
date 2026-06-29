import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/features/login/presentation/views/widgets/login_view_body.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kprimaryColor,
      body: LoginViewBody(),
    );
  }
}
