import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffDCE3EC)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 20, height: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
