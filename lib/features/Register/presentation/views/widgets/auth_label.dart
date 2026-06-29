import 'package:flutter/material.dart';

class AuthLabel extends StatelessWidget {
  const AuthLabel({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        fontSize: 14,
      ),
    );
  }
}