import 'package:flutter/material.dart';

class DashboardStateModel {
  final String title;
  final String value;
  final String badge;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;

  DashboardStateModel({
    required this.title,
    required this.value,
    required this.badge,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });
}

List<DashboardStateModel> dashboardStates = [
  DashboardStateModel(
    title: "Total Bookings",
    value: "1,248",
    badge: "+12%",
    icon: Icons.menu_book_rounded,
    iconBackground: const Color(0xffE7F0FF),
    iconColor: const Color(0xff2563EB),
  ),

  DashboardStateModel(
    title: "Today's Appts",
    value: "34",
    badge: "+5",
    icon: Icons.calendar_month_rounded,
    iconBackground: const Color(0xffDDFBF0),
    iconColor: const Color(0xff0B9B7B),
  ),

  DashboardStateModel(
    title: "Revenue",
    value: "\$8,920",
    badge: "+18%",
    icon: Icons.attach_money_rounded,
    iconBackground: const Color(0xffFFF3D6),
    iconColor: const Color(0xffF59E0B),
  ),

  DashboardStateModel(
    title: "Active Providers",
    value: "12",
    badge: "+2",
    icon: Icons.groups_2_rounded,
    iconBackground: const Color(0xffFFE6F2),
    iconColor: const Color(0xffEC4899),
  ),
];
