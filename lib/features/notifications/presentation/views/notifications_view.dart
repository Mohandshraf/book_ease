import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Center(
          child: ScaleOnTap(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.unreadCount > 0) {
                return ScaleOnTap(
                  onTap: () {
                    context.read<NotificationCubit>().markAllAsRead();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentLilacLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accentLilac.withValues(alpha: 0.2)),
                    ),
                    child: const Center(
                      child: Text(
                        "Mark all read",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is NotificationFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cancelledLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.error_outline_rounded, size: 36, color: AppColors.cancelled),
                    ),
                    const Gap(16),
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const Gap(20),
                    ScaleOnTap(
                      onTap: () {
                        context.read<NotificationCubit>().subscribeToNotifications();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Retry",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: AppColors.accentLilacLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentLilac.withValues(alpha: 0.2), width: 2),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        size: 42,
                        color: AppColors.primary,
                      ),
                    ),
                    const Gap(18),
                    const Text(
                      "No Notifications Yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      "You'll see updates about bookings and messages here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
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
