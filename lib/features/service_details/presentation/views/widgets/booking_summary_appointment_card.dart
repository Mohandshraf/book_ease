import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingSummaryAppointmentCard extends StatelessWidget {
  final String formattedDate;
  final String selectedTime;
  final String providerName;
  final String location;

  const BookingSummaryAppointmentCard({
    super.key,
    required this.formattedDate,
    required this.selectedTime,
    required this.providerName,
    this.location = "123 Medical Center Dr.",
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
            context.tr('summary_details_title'),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(18),
          _buildDetailsRow(
            icon: Icons.calendar_today_outlined,
            label: context.tr('summary_date'),
            value: formattedDate,
          ),
          const Gap(14),
          _buildDetailsRow(
            icon: Icons.access_time_rounded,
            label: context.tr('summary_time'),
            value: selectedTime,
          ),
          const Gap(14),
          _buildDetailsRow(
            icon: Icons.location_on_outlined,
            label: context.tr('summary_location'),
            value: location,
          ),
          const Gap(14),
          _buildDetailsRow(
            icon: Icons.person_outline_rounded,
            label: context.tr('summary_doctor'),
            value: providerName,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentLilacLight,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
