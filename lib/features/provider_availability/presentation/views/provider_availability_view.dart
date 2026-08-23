import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/provider_availability/presentation/views/widgets/provider_availability_view_body.dart';
import 'package:flutter/material.dart';

class ProviderAvailabilityView extends StatelessWidget {
  const ProviderAvailabilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Working Hours & Availability',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const ProviderAvailabilityViewBody(),
    );
  }
}
