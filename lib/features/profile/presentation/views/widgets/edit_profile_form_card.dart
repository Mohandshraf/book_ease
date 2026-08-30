import 'package:book_ease/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EditProfileFormCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final ValueChanged<String>? onNameChanged;

  const EditProfileFormCard({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          const Text(
            "Full Name",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your name";
              }
              return null;
            },
            onChanged: onNameChanged,
            decoration: InputDecoration(
              hintText: "Your full name",
              hintStyle: const TextStyle(color: AppColors.textLight),
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.surfaceMuted,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Email Field
          const Text(
            "Email Address",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: emailController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: "Your email address",
              hintStyle: const TextStyle(color: AppColors.textLight),
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.textLight,
              ),
              suffixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.textLight,
                size: 18,
              ),
              filled: true,
              fillColor: AppColors.surfaceMuted,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Email cannot be changed directly for security",
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 20),

          // Phone Number Field
          const Text(
            "Phone Number",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "+1 (555) 000-0000",
              hintStyle: const TextStyle(color: AppColors.textLight),
              prefixIcon: const Icon(
                Icons.phone_outlined,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.surfaceMuted,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
