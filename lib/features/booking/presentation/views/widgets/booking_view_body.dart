import 'package:flutter/material.dart';
import 'booking_card.dart';

class BookingViewBody extends StatelessWidget {
  const BookingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        BookingCard(
          image: "https://picsum.photos/200",
          name: "Dr. Sarah Mitchell",
          service: "General Checkup",
          date: "Jul 15, 2024",
          time: "10:30 AM",
          price: "80.00",
          status: "confirmed",
          onCancel: () {},
          onReschedule: () {},
        ),

        BookingCard(
          image: "https://picsum.photos/201",
          name: "James Rodriguez",
          service: "Premium Haircut",
          date: "Jul 18, 2024",
          time: "2:00 PM",
          price: "35.00",
          status: "confirmed",
          onCancel: () {},
          onReschedule: () {},
        ),
      ],
    );
  }
}
