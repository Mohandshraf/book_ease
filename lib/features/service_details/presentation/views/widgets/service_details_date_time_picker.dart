import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/service_details/data/cubit/booking_date_cubit.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ServiceDetailsDateTimePicker extends StatefulWidget {
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
  State<ServiceDetailsDateTimePicker> createState() =>
      _ServiceDetailsDateTimePickerState();
}

class _ServiceDetailsDateTimePickerState
    extends State<ServiceDetailsDateTimePicker> {
  int _currentMonthIndex = 0;
  final List<String> _months = [
    "November 2025",
    "December 2025",
    "January 2026",
    "February 2026"
  ];

  @override
  Widget build(BuildContext context) {
    final availableDates = widget.model.availableDates.isNotEmpty
        ? widget.model.availableDates
        : mockServiceDetails.availableDates;
    final availableTimes = widget.model.availableTimes.isNotEmpty
        ? widget.model.availableTimes
        : mockServiceDetails.availableTimes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. "Select Date" Header & Month Navigator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Select Date",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            // Month Switcher
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_currentMonthIndex > 0) {
                        setState(() {
                          _currentMonthIndex--;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    _months[_currentMonthIndex % _months.length],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Gap(4),
                  GestureDetector(
                    onTap: () {
                      if (_currentMonthIndex < _months.length - 1) {
                        setState(() {
                          _currentMonthIndex++;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const Gap(14),

        // Horizontal Days Selector
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            separatorBuilder: (context, index) => const Gap(10),
            itemBuilder: (context, index) {
              final option = availableDates[index];
              final isSelected =
                  widget.selectedDate.day == option.date.day &&
                      widget.selectedDate.month == option.date.month;

              return ScaleOnTap(
                onTap: () {
                  try {
                    context.read<BookingSelectionCubit>().selectDate(option);
                  } catch (_) {}
                  widget.onDateSelected(option.date);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 62,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: .28),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: .02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        option.dayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white.withValues(alpha: .9)
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        "${option.dayNumber}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const Gap(26),

        // 2. "Select Time" Header & Slot Counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Select Time",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${availableTimes.length} Slots",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const Gap(14),

        // Time Pills Grid
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: availableTimes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final time = availableTimes[index];
            final isSelected = widget.selectedTime == time;

            return ScaleOnTap(
              onTap: () {
                try {
                  context.read<BookingSelectionCubit>().selectTime(time);
                } catch (_) {}
                widget.onTimeSelected(time);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: .25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
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
