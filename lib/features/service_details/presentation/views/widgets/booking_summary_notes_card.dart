import 'package:book_ease/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingSummaryNotesCard extends StatelessWidget {
  final TextEditingController? controller;

  const BookingSummaryNotesCard({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Notes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff0B1F44),
            ),
          ),
          const Gap(12),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Any special requests or medical notes...",
              hintStyle: const TextStyle(
                color: Color(0xff94A3B8),
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.all(16),
              filled: true,
              fillColor: const Color(0xffF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xffE2E8F0),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xffE2E8F0),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.ksecondColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
