import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/booking/presentation/views/booking_view.dart';
import 'package:book_ease/features/discover/presentation/views/discover_view.dart';
import 'package:book_ease/features/home/presentation/views/widgets/home_view.dart';
import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_state.dart';
import 'package:book_ease/features/messages/presentation/views/messages_view.dart';
import 'package:book_ease/features/profile/presentation/views/profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerRootView extends StatefulWidget {
  final int initialIndex;

  const CustomerRootView({super.key, this.initialIndex = 0});

  static void navigateToTab(BuildContext context, int tabIndex) {
    final rootState = context.findAncestorStateOfType<_CustomerRootViewState>();
    if (rootState != null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      rootState.setTab(tabIndex);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.customerRoot,
        (route) => false,
        arguments: tabIndex,
      );
    }
  }

  @override
  State<CustomerRootView> createState() => _CustomerRootViewState();
}

class _CustomerRootViewState extends State<CustomerRootView> {
  late int currentIndex;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    context.read<ChatCubit>().initConversations();
    pages = [
      const HomeView(),
      const DiscoverView(),
      const BookingView(),
      const MessagesView(),
      const ProfileView(),
    ];
  }

  @override
  void didUpdateWidget(covariant CustomerRootView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setTab(widget.initialIndex);
    }
  }

  void setTab(int index) {
    if (index >= 0 && index < pages.length) {
      setState(() {
        currentIndex = index;
      });
      if (index == 2) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null && uid.isNotEmpty) {
          try {
            context.read<BookingCubit>().getUserBookings(uid);
          } catch (_) {}
        }
      }
    }
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
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, chatState) {
                  final unreadCount =
                      chatState.conversations.where((c) => c.unread).length;
                  return _buildNavItem(
                    3,
                    Icons.chat_bubble_rounded,
                    Icons.chat_bubble_outline_rounded,
                    "Messages",
                    badgeCount: unreadCount,
                  );
                },
              ),
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
    String label, {
    int badgeCount = 0,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        setTab(index);
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.white,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.45),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 9 ? '9+' : '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
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

