import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/features/service_details/data/cubit/booking_date_cubit.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ServiceDetailsDateTimePicker extends StatelessWidget {
  final ServiceDetailsModel model;
  final DateTime selectedDate;
  final String selectedTime;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String> onTimeSelected;

  const ServiceDetailsDateTimePicker({
    super.key,
    required this.model,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Date",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff0B1F44),
          ),
        ),
        const Gap(12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: model.availableDates.length,
            separatorBuilder: (context, index) => const Gap(12),
            itemBuilder: (context, index) {
              final option = model.availableDates[index];
              final isSelected = selectedDate.day == option.date.day &&
                  selectedDate.month == option.date.month;
              return GestureDetector(
                onTap: () {
                  context.read<BookingSelectionCubit>().selectDate(option);
                  onDateSelected(option.date);
                },
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.ksecondColor : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.ksecondColor
                          : const Color(0xffE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        option.dayName,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xff94A3B8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        "${option.dayNumber}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xff0B1F44),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Gap(24),
        const Text(
          "Available Times",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff0B1F44),
          ),
        ),
        const Gap(12),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: model.availableTimes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final time = model.availableTimes[index];
            final isSelected = selectedTime == time;
            return GestureDetector(
              onTap: () {
                context.read<BookingSelectionCubit>().selectTime(time);
                onTimeSelected(time);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ksecondColor : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.ksecondColor
                        : const Color(0xffE2E8F0),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected ? Colors.white : const Color(0xff0B1F44),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
