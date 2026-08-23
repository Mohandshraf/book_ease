import 'package:book_ease/features/notifications/data/models/notification_model.dart';

abstract class NotificationRepo {
  Stream<List<NotificationModel>> getNotificationsStream([String? userId]);
  Future<void> createNotification(NotificationModel notification);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead([String? userId]);
  Future<void> deleteNotification(String notificationId);
}
