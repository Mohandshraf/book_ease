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
  DateTime? _displayedMonth;

  DateTime get _displayedMonthSafe {
    return _displayedMonth ??=
        DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
  }

  static const List<String> _shortMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static const List<String> _weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  static const List<String> _weekdayHeaders = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat"
  ];

  @override
  void initState() {
    super.initState();
    _displayedMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
  }

  @override
  void didUpdateWidget(covariant ServiceDetailsDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      if (widget.selectedDate.year != _displayedMonthSafe.year ||
          widget.selectedDate.month != _displayedMonthSafe.month) {
        _displayedMonth =
            DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
      }
    }
  }

  bool get _canGoPreviousMonth {
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month, 1);
    return _displayedMonthSafe.isAfter(currentMonthStart);
  }

  void _goToPreviousMonth() {
    if (_canGoPreviousMonth) {
      setState(() {
        _displayedMonth = DateTime(
          _displayedMonthSafe.year,
          _displayedMonthSafe.month - 1,
          1,
        );
      });
    }
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonthSafe.year,
        _displayedMonthSafe.month + 1,
        1,
      );
    });
  }

  void _onDateTap(DateTime date) {
    const dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final option = DateOption(
      dayName: dayNames[date.weekday - 1],
      dayNumber: date.day,
      date: date,
    );
    try {
      context.read<BookingSelectionCubit>().selectDate(option);
    } catch (_) {}
    widget.onDateSelected(date);
  }

  Color? _getIndicatorDotColor(int dayNumber, bool isPast, bool isSelected) {
    if (isPast || isSelected) return null;
    // Multi-color accent dots matching reference design (teal, pink, primary blue)
    switch (dayNumber % 4) {
      case 0:
        return const Color(0xFF10B981); // Emerald / Teal
      case 1:
        return const Color(0xFFEC4899); // Soft Pink / Coral
      case 2:
        return AppColors.primary; // App Primary Blue
      case 3:
        return const Color(0xFF8B5CF6); // Violet / Lilac
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableTimes = widget.model.availableTimes.isNotEmpty
        ? widget.model.availableTimes
        : mockServiceDetails.availableTimes;

    final currentMonth = _displayedMonthSafe;

    // Determine which date to display in the header
    final headerDate = (currentMonth.year == widget.selectedDate.year &&
            currentMonth.month == widget.selectedDate.month)
        ? widget.selectedDate
        : DateTime(currentMonth.year, currentMonth.month, 1);

    final dateString =
        "${headerDate.day} ${_shortMonths[headerDate.month - 1]}, ${headerDate.year.toString().substring(2)}";
    final weekdayString = _weekdays[headerDate.weekday - 1];

    final firstDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    // Starts on Sunday (Sunday = 0, Monday = 1, ..., Saturday = 6)
    final startingWeekdayOffset = firstDayOfMonth.weekday % 7;
    final totalGridItems = startingWeekdayOffset + daysInMonth;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================
        // 1. CALENDAR CARD (Matching User Screenshot)
        // ==========================================
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.8),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header: Date + Weekday + Month Navigation Arrows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        dateString,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        weekdayString,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleOnTap(
                        onTap: _canGoPreviousMonth ? _goToPreviousMonth : null,
                        child: Opacity(
                          opacity: _canGoPreviousMonth ? 1.0 : 0.3,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_left_rounded,
                              size: 22,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ScaleOnTap(
                        onTap: _goToNextMonth,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            size: 22,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Gap(18),

              // Weekday Names Header Row (Sun Mon Tue Wed Thu Fri Sat)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _weekdayHeaders
                    .map(
                      (header) => Expanded(
                        child: Center(
                          child: Text(
                            header,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const Gap(12),

              // Calendar Days 7-Column Grid
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalGridItems,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 0.88,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  if (index < startingWeekdayOffset) {
                    return const SizedBox.shrink();
                  }

                  final dayNumber = index - startingWeekdayOffset + 1;
                  final date = DateTime(
                    currentMonth.year,
                    currentMonth.month,
                    dayNumber,
                  );
                  final isPast = date.isBefore(today);
                  final isSelected = date.year == widget.selectedDate.year &&
                      date.month == widget.selectedDate.month &&
                      date.day == widget.selectedDate.day;
                  final isToday = date.year == today.year &&
                      date.month == today.month &&
                      date.day == today.day;
                  final dotColor =
                      _getIndicatorDotColor(dayNumber, isPast, isSelected);

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: isPast ? null : () => _onDateTap(date),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            border: (isToday && !isSelected)
                                ? Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.4),
                                    width: 1.5,
                                  )
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "$dayNumber",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : (isToday ? FontWeight.w700 : FontWeight.w500),
                              color: isSelected
                                  ? Colors.white
                                  : (isPast
                                      ? AppColors.textMuted
                                          .withValues(alpha: 0.35)
                                      : AppColors.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        if (dotColor != null)
                          Container(
                            width: 4.5,
                            height: 4.5,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          const SizedBox(height: 4.5),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const Gap(24),

        // ==========================================
        // 2. TIME SELECTION SECTION
        // ==========================================
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
                            color: AppColors.primary.withValues(alpha: 0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
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
