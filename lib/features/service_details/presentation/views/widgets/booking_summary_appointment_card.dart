import 'package:book_ease/core/app_colors.dart';
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
            "Appointment Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff0B1F44),
            ),
          ),
          const Gap(20),
          _buildDetailsRow(
            icon: Icons.calendar_today_outlined,
            label: "Date",
            value: formattedDate,
          ),
          const Gap(16),
          _buildDetailsRow(
            icon: Icons.access_time_rounded,
            label: "Time",
            value: selectedTime,
          ),
          const Gap(16),
          _buildDetailsRow(
            icon: Icons.location_on_outlined,
            label: "Location",
            value: location,
          ),
          const Gap(16),
          _buildDetailsRow(
            icon: Icons.person_outline_rounded,
            label: "Doctor",
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
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffDDFBF0),
          ),
          child: Icon(icon, color: AppColors.ksecondColor, size: 20),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xff94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xff0B1F44),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
