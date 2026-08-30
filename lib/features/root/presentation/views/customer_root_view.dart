import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/booking/presentation/views/booking_view.dart';
import 'package:book_ease/features/discover/presentation/views/discover_view.dart';
import 'package:book_ease/features/home/presentation/views/widgets/home_view.dart';
import 'package:book_ease/features/messages/presentation/views/messages_view.dart';
import 'package:book_ease/features/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';

class CustomerRootView extends StatefulWidget {
  const CustomerRootView({super.key});

  @override
  State<CustomerRootView> createState() => _CustomerRootViewState();
}

class _CustomerRootViewState extends State<CustomerRootView> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HomeView(),
      const DiscoverView(),
      const BookingView(),
      const MessagesView(),
      const ProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: AppColors.border.withValues(alpha: .8),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: .08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: .02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, "Home"),
              _buildNavItem(1, Icons.explore_rounded, Icons.explore_outlined, "Discover"),
              _buildNavItem(2, Icons.calendar_month_rounded, Icons.calendar_month_outlined, "Bookings"),
              _buildNavItem(3, Icons.chat_bubble_rounded, Icons.chat_bubble_outline_rounded, "Messages"),
              _buildNavItem(4, Icons.person_rounded, Icons.person_outline_rounded, "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
