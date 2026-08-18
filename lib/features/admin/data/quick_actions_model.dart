import 'package:flutter/material.dart';

class QuickActionModel {
  final String title;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;

  const QuickActionModel({
    required this.title,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });
}

List<QuickActionModel> quickActions = [
  QuickActionModel(
    title: "Manage Slots",
    icon: Icons.calendar_month_rounded,
    iconBackground: const Color(0xffDDFBF0),
    iconColor: const Color(0xff0B9B7B),
  ),

  QuickActionModel(
    title: "Add Provider",
    icon: Icons.add,
    iconBackground: const Color(0xffDDFBF0),
    iconColor: const Color(0xff0B9B7B),
  ),

  QuickActionModel(
    title: "Reports",
    icon: Icons.trending_up_rounded,
    iconBackground: const Color(0xffDDFBF0),
    iconColor: const Color(0xff0B9B7B),
  ),
];
