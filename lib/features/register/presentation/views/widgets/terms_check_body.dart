import 'package:flutter/material.dart';

class TermsCheckBox extends StatelessWidget {
  const TermsCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  final bool value;
  final Color color;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.15,
          child: Checkbox(
            value: value,
            activeColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
              children: [
                const TextSpan(text: "I agree to the "),
                TextSpan(
                  text: "Terms of Service",
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}