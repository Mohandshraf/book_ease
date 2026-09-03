import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: .04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('summary_price_title'),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(16),
          _buildPriceRow(
            label: context.tr('summary_consultation_fee'),
            value: "\$${consultationFee.toStringAsFixed(2)}",
          ),
          const Gap(12),
          _buildPriceRow(
            label: context.tr('summary_booking_fee'),
            value: "\$${bookingFee.toStringAsFixed(2)}",
          ),
          const Gap(12),
          _buildPriceRow(
            label: context.tr('summary_discount'),
            value: "-\$${memberDiscount.toStringAsFixed(2)}",
            isDiscount: true,
          ),
          const Gap(16),
          const Divider(color: AppColors.border, thickness: 1),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('summary_total'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                "\$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
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
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
            fontSize: 14,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
