import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_state.dart';
import 'package:book_ease/features/messages/presentation/views/messages_view.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/provider_bookings/presentation/views/provider_bookings_view.dart';
import 'package:book_ease/features/provider_dashboard/presentation/views/provider_dashboard_view.dart';
import 'package:book_ease/features/provider_profile/presentation/views/provider_profile_view.dart';
import 'package:book_ease/features/provider_services/presentation/views/provider_services_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<ChatCubit>().initConversations();
    context.read<NotificationCubit>().subscribeToNotifications();
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
              _buildNavItem(0, Icons.dashboard_rounded, Icons.dashboard_outlined, context.tr('nav_dashboard')),
              _buildNavItem(1, Icons.calendar_month_rounded, Icons.calendar_month_outlined, context.tr('nav_bookings')),
              _buildNavItem(2, Icons.medical_services_rounded, Icons.medical_services_outlined, context.tr('nav_services')),
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, chatState) {
                  final unreadCount =
                      chatState.conversations.where((c) => c.unread).length;
                  return _buildNavItem(
                    3,
                    Icons.chat_bubble_rounded,
                    Icons.chat_bubble_outline_rounded,
                    context.tr('nav_messages'),
                    badgeCount: unreadCount,
                  );
                },
              ),
              _buildNavItem(4, Icons.person_rounded, Icons.person_outline_rounded, context.tr('nav_profile')),
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

