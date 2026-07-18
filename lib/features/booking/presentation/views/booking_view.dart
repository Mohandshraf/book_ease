import 'package:book_ease/features/booking/presentation/views/widgets/booking_view_body.dart';
import 'package:flutter/material.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: BookingViewBody(),
    );
  }
}
