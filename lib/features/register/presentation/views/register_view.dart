import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/register/presentation/views/widgets/register_view_body.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kprimaryColor,
      body: RegisterViewBody(),
    );
  }
}
