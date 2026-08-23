import 'package:book_ease/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaymentCardForm extends StatelessWidget {
  final TextEditingController numberController;
  final TextEditingController holderController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;

  const PaymentCardForm({
    super.key,
    required this.numberController,
    required this.holderController,
    required this.expiryController,
    required this.cvvController,
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
            "Card Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff0B1F44),
            ),
          ),
          const Gap(20),

          // Card Number Field
          const Text(
            "CARD NUMBER",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xff94A3B8),
              letterSpacing: 1,
            ),
          ),
          const Gap(8),
          _buildTextField(
            controller: numberController,
            icon: Icons.credit_card_outlined,
          ),
          const Gap(16),

          // Card Holder Field
          const Text(
            "CARD HOLDER",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xff94A3B8),
              letterSpacing: 1,
            ),
          ),
          const Gap(8),
          _buildTextField(
            controller: holderController,
            icon: Icons.person_outline_rounded,
          ),
          const Gap(16),

          // Expiry & CVV Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "EXPIRY",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff94A3B8),
                        letterSpacing: 1,
                      ),
                    ),
                    const Gap(8),
                    _buildTextField(
                      controller: expiryController,
                      icon: Icons.date_range_outlined,
                    ),
                  ],
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "CVV",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff94A3B8),
                        letterSpacing: 1,
                      ),
                    ),
                    const Gap(8),
                    _buildTextField(
                      controller: cvvController,
                      icon: Icons.lock_outline_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: const Color(0xff94A3B8),
          size: 20,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: const Color(0xffF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xffE2E8F0),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xffE2E8F0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.ksecondColor,
            width: 1,
          ),
        ),
      ),
      style: const TextStyle(
        color: Color(0xff0B1F44),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
