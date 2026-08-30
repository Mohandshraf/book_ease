import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/booking/presentation/views/widgets/booking_view_body.dart';
import 'package:flutter/material.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: BookingViewBody(),
    );
  }
}
