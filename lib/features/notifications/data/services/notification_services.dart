import 'package:book_ease/features/notifications/data/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationServices {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotificationServices({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser?.uid ?? '';

  Future<void> createNotification(NotificationModel notification) async {
    if (notification.userId.isEmpty) return;
    await _firestore.collection('notifications').add(notification.toJson());
  }

  Stream<List<NotificationModel>> getNotificationsStream([String? userId]) {
    final uid = (userId != null && userId.isNotEmpty) ? userId : currentUserId;
    if (uid.isEmpty) return Stream.value([]);

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data(), doc.id))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    }).handleError((_) => <NotificationModel>[]);
  }

  Future<void> markAsRead(String notificationId) async {
    if (notificationId.isEmpty) return;
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    }).catchError((_) {});
  }

  Future<void> markAllAsRead([String? userId]) async {
    final uid = (userId != null && userId.isNotEmpty) ? userId : currentUserId;
    if (uid.isEmpty) return;

    final userDocs = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .get();

    final batch = _firestore.batch();
    var hasUpdates = false;
    for (var doc in userDocs.docs) {
      final data = doc.data();
      if (data['isRead'] != true) {
        batch.update(doc.reference, {'isRead': true});
        hasUpdates = true;
      }
    }
    if (hasUpdates) {
      await batch.commit().catchError((_) {});
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    if (notificationId.isEmpty) return;
    await _firestore.collection('notifications').doc(notificationId).delete().catchError((_) {});
  }
}
