import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/core/di/service_locator.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_state.dart';
import 'package:book_ease/features/notifications/presentation/views/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationCubit>()..subscribeToNotifications(),
      child: const _NotificationsViewContent(),
    );
  }
}

class _NotificationsViewContent extends StatelessWidget {
  const _NotificationsViewContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xff0B1F44)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Color(0xff0B1F44),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.unreadCount > 0) {
                return TextButton(
                  onPressed: () {
                    context.read<NotificationCubit>().markAllAsRead();
                  },
                  child: const Text(
                    "Mark all read",
                    style: TextStyle(
                      color: AppColors.ksecondColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const Gap(8),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.ksecondColor),
            );
          }

          if (state is NotificationFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                    const Gap(12),
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xff64748B), fontSize: 14),
                    ),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NotificationCubit>().subscribeToNotifications();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ksecondColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xffEAFDF6),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xffD1F2E8), width: 2),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        size: 40,
                        color: AppColors.ksecondColor,
                      ),
                    ),
                    const Gap(16),
                    const Text(
                      "No Notifications Yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B1F44),
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      "You'll see updates about bookings and messages here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff64748B),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => const Gap(12),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead && notification.id != null) {
                      context.read<NotificationCubit>().markAsRead(notification.id!);
                    }
                  },
                  onDelete: () {
                    if (notification.id != null) {
                      context.read<NotificationCubit>().deleteNotification(notification.id!);
                    }
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
