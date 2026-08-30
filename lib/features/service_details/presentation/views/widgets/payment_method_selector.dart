import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
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
            label: "Card",
            icon: Icons.credit_card_rounded,
          ),
        ),
        const Gap(10),
        Expanded(
          child: _buildMethodButton(
            index: 1,
            label: "PayPal",
            icon: Icons.account_balance_wallet_outlined,
          ),
        ),
        const Gap(10),
        Expanded(
          child: _buildMethodButton(
            index: 2,
            label: "Apple Pay",
            icon: Icons.apple_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildMethodButton({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isSelected = selectedIndex == index;
    return ScaleOnTap(
      onTap: () => onMethodSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
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
              : [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: .03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const Gap(6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
