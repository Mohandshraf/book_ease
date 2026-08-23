import 'package:book_ease/features/notifications/data/models/notification_model.dart';
import 'package:book_ease/features/notifications/data/repo/notification_repo.dart';
import 'package:book_ease/features/notifications/data/services/notification_services.dart';

class NotificationRepoImpl implements NotificationRepo {
  final NotificationServices _notificationServices;

  NotificationRepoImpl(this._notificationServices);

  @override
  Stream<List<NotificationModel>> getNotificationsStream([String? userId]) {
    return _notificationServices.getNotificationsStream(userId);
  }

  @override
  Future<void> createNotification(NotificationModel notification) {
    return _notificationServices.createNotification(notification);
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _notificationServices.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead([String? userId]) {
    return _notificationServices.markAllAsRead(userId);
  }

  @override
  Future<void> deleteNotification(String notificationId) {
    return _notificationServices.deleteNotification(notificationId);
  }
}
