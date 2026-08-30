import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/settings/presentation/views/widgets/settings_view_body.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SettingsViewBody(),
      ),
    );
  }
}
