import 'package:book_ease/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppointmentSlotsSection extends StatelessWidget {
  final List<String> slots;
  final VoidCallback onAddSlot;
  final ValueChanged<String> onRemoveSlot;

  const AppointmentSlotsSection({
    super.key,
    required this.slots,
    required this.onAddSlot,
    required this.onRemoveSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daily Appointment Slots',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: onAddSlot,
              icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
              label: const Text(
                'Add Slot',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'These time slots are displayed to clients on active working days',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        if (slots.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'No slots configured yet. Click "Add Slot" to add times.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((slot) {
              return Chip(
                label: Text(slot),
                backgroundColor: Colors.white,
                deleteIcon: const Icon(
                  Icons.cancel,
                  size: 18,
                  color: AppColors.error,
                ),
                onDeleted: () => onRemoveSlot(slot),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
