import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/provider_bookings/presentation/views/widgets/provider_bookings_view_body.dart';
import 'package:flutter/material.dart';

class ProviderBookingsView extends StatelessWidget {
  const ProviderBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: ProviderBookingsViewBody(),
    );
  }
}
