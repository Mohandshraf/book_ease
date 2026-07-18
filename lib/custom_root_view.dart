import 'package:book_ease/features/home/presentation/views/widgets/home_view.dart';
import 'package:book_ease/features/discover/presentation/views/discover_view.dart';
import 'package:book_ease/features/booking/presentation/views/booking_view.dart';
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
                _buildNavItem(0, Icons.home_outlined, "Home"),
                _buildNavItem(1, Icons.search_rounded, "Discover"),
                _buildNavItem(2, Icons.calendar_month_outlined, "Bookings"),
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
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xffEAFDF6) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xff0B9B7B) : const Color(0xff7E8CA0),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xff0B9B7B) : const Color(0xff7E8CA0),
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

