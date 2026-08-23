import 'dart:async';
import 'package:book_ease/features/notifications/data/cubit/notification_state.dart';
import 'package:book_ease/features/notifications/data/models/notification_model.dart';
import 'package:book_ease/features/notifications/data/repo/notification_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _repo;
  StreamSubscription<List<NotificationModel>>? _subscription;

  NotificationCubit(this._repo) : super(NotificationInitial());

  void subscribeToNotifications([String? userId]) {
    emit(NotificationLoading());
    _subscription?.cancel();
    _subscription = _repo.getNotificationsStream(userId).listen(
      (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;
        emit(NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ));
      },
      onError: (e) {
        emit(NotificationFailure(e.toString()));
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repo.markAsRead(notificationId);
    } catch (_) {}
  }

  Future<void> markAllAsRead([String? userId]) async {
    try {
      await _repo.markAllAsRead(userId);
    } catch (_) {}
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _repo.deleteNotification(notificationId);
    } catch (_) {}
  }

  void reset() {
    _subscription?.cancel();
    _subscription = null;
    emit(NotificationInitial());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
