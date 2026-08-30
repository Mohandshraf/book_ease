import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: ProfileViewBody(),
    );
  }
}
