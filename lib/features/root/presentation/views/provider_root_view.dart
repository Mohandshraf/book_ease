import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/messages/presentation/views/messages_view.dart';
import 'package:book_ease/features/provider_bookings/presentation/views/provider_bookings_view.dart';
import 'package:book_ease/features/provider_dashboard/presentation/views/provider_dashboard_view.dart';
import 'package:book_ease/features/provider_profile/presentation/views/provider_profile_view.dart';
import 'package:book_ease/features/provider_services/presentation/views/provider_services_view.dart';
import 'package:flutter/material.dart';

class ProviderRootView extends StatefulWidget {
  const ProviderRootView({super.key});

  @override
  State<ProviderRootView> createState() => _ProviderRootViewState();
}

class _ProviderRootViewState extends State<ProviderRootView> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      ProviderDashboardView(
        onTabChangeRequested: (index) => setState(() => currentIndex = index),
      ),
      const ProviderBookingsView(),
      const ProviderServicesView(),
      const MessagesView(),
      const ProviderProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_outlined, "Dashboard"),
                _buildNavItem(1, Icons.calendar_month_outlined, "Bookings"),
                _buildNavItem(2, Icons.medical_services_outlined, "Services"),
                _buildNavItem(3, Icons.chat_bubble_outline_rounded, "Messages"),
                _buildNavItem(4, Icons.person_outline_rounded, "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : const Color(0xff7E8CA0),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : const Color(0xff7E8CA0),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
