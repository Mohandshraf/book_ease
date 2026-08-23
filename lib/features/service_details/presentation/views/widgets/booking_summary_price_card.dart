import 'package:book_ease/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingSummaryPriceCard extends StatelessWidget {
  final double consultationFee;
  final double bookingFee;
  final double memberDiscount;
  final double totalPrice;

  const BookingSummaryPriceCard({
    super.key,
    required this.consultationFee,
    required this.bookingFee,
    required this.memberDiscount,
    required this.totalPrice,
  });

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
            "Price Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff0B1F44),
            ),
          ),
          const Gap(16),
          _buildPriceRow(
            label: "Consultation fee",
            value: "\$${consultationFee.toStringAsFixed(2)}",
          ),
          const Gap(12),
          _buildPriceRow(
            label: "Booking fee",
            value: "\$${bookingFee.toStringAsFixed(2)}",
          ),
          const Gap(12),
          _buildPriceRow(
            label: "Member discount",
            value: "-\$${memberDiscount.toStringAsFixed(2)}",
            isDiscount: true,
          ),
          const Gap(16),
          const Divider(color: Color(0xffE2E8F0), thickness: 1),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0B1F44),
                ),
              ),
              Text(
                "\$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ksecondColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff64748B),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? AppColors.ksecondColor : const Color(0xff0B1F44),
            fontSize: 15,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
