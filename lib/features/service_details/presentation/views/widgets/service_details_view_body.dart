import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/service_details_date_time_picker.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/service_details_info_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ServiceDetailsViewBody extends StatelessWidget {
  const ServiceDetailsViewBody({
    super.key,
    required this.model,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  final ServiceDetailsModel model;
  final DateTime selectedDate;
  final String selectedTime;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String> onTimeSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiceDetailsInfoSection(model: model),
          const Gap(24),
          ServiceDetailsDateTimePicker(
            model: model,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            onDateSelected: onDateSelected,
            onTimeSelected: onTimeSelected,
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
