import 'package:flutter/material.dart';

class ChatActionBar extends StatelessWidget {
  final VoidCallback? onDetailsTap;
  final VoidCallback? onRescheduleTap;

  const ChatActionBar({
    super.key,
    this.onDetailsTap,
    this.onRescheduleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Button: Appointment details
        GestureDetector(
          onTap: onDetailsTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xffEAFDF6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xff0B9B7B),
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  "Appointment details",
                  style: TextStyle(
                    color: Color(0xff0B9B7B),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Button: Reschedule
        GestureDetector(
          onTap: onRescheduleTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xffE2E8F0),
              ),
            ),
            child: const Center(
              child: Text(
                "Reschedule",
                style: TextStyle(
                  color: Color(0xff334155),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
