import 'package:book_ease/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaymentMethodSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onMethodSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selectedIndex,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMethodButton(
            index: 0,
            label: "Credit Card",
          ),
        ),
        const Gap(12),
        Expanded(
          child: _buildMethodButton(
            index: 1,
            label: "PayPal",
          ),
        ),
        const Gap(12),
        Expanded(
          child: _buildMethodButton(
            index: 2,
            label: "Apple Pay",
          ),
        ),
      ],
    );
  }

  Widget _buildMethodButton({required int index, required String label}) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onMethodSelected(index),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.ksecondColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.ksecondColor : const Color(0xffE2E8F0),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xff64748B),
            ),
          ),
        ),
      ),
    );
  }
}
