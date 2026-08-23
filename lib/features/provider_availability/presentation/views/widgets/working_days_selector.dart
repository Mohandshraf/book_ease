import 'package:book_ease/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WorkingDaysSelector extends StatelessWidget {
  final List<String> allDays;
  final List<String> selectedDays;
  final ValueChanged<String> onDayToggled;

  const WorkingDaysSelector({
    super.key,
    required this.allDays,
    required this.selectedDays,
    required this.onDayToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Working Days',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select the days of the week you are available for appointments',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allDays.map((day) {
            final isSelected = selectedDays.contains(day);
            return FilterChip(
              label: Text(day),
              selected: isSelected,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              onSelected: (_) => onDayToggled(day),
            );
          }).toList(),
        ),
      ],
    );
  }
}
