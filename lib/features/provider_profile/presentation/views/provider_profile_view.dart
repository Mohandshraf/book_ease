import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/provider_profile/presentation/views/widgets/provider_profile_view_body.dart';
import 'package:flutter/material.dart';

class ProviderProfileView extends StatelessWidget {
  const ProviderProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: ProviderProfileViewBody(),
    );
  }
}
