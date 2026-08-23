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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              color: Color(0xff0B1F44),
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
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xff64748B),
              ),
              filled: true,
              fillColor: const Color(0xffF8FAFC),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xffE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xffE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xff0B9B7B), width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Email Field
          const Text(
            "Email Address",
            style: TextStyle(
              color: Color(0xff0B1F44),
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
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Color(0xff94A3B8),
              ),
              suffixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xff94A3B8),
                size: 18,
              ),
              filled: true,
              fillColor: const Color(0xffF1F5F9),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Email cannot be changed directly for security",
            style: TextStyle(
              color: Color(0xff94A3B8),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 20),

          // Phone Number Field
          const Text(
            "Phone Number",
            style: TextStyle(
              color: Color(0xff0B1F44),
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
              prefixIcon: const Icon(
                Icons.phone_outlined,
                color: Color(0xff64748B),
              ),
              filled: true,
              fillColor: const Color(0xffF8FAFC),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xffE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xffE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xff0B9B7B), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
