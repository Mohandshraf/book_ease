import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/provider_services/presentation/views/widgets/provider_services_view_body.dart';
import 'package:flutter/material.dart';

class ProviderServicesView extends StatelessWidget {
  const ProviderServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: ProviderServicesViewBody(),
    );
  }
}
