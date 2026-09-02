import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/notifications/data/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingRepoImpl implements BookingRepo {
  final FirebaseFirestore _firestore;

  BookingRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createBooking(BookingModel booking) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? booking.customerId;

    String? name = booking.customerName ?? user?.displayName;
    String? email = booking.customerEmail ?? user?.email;

    if ((name == null || name.isEmpty) && uid.isNotEmpty) {
      try {
        final userDoc = await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          name = userDoc.data()?['name'];
          email ??= userDoc.data()?['email'];
        }
      } catch (_) {}
    }

    final finalBooking = BookingModel(
      id: booking.id,
      customerId: uid.isNotEmpty ? uid : booking.customerId,
      customerName: name,
      customerEmail: email,
      providerId: booking.providerId,
      providerName: booking.providerName,
      serviceId: booking.serviceId,
      serviceTitle: booking.serviceTitle,
      price: booking.price,
      bookingDate: booking.bookingDate,
      bookingTime: booking.bookingTime,
      status: booking.status,
      createdAt: booking.createdAt,
      notes: booking.notes,
    );

    final docRef =
        await _firestore.collection('bookings').add(finalBooking.toJson());

    // Automatically create Notification for Provider
    if (finalBooking.providerId.isNotEmpty) {
      final patientName =
          (finalBooking.customerName != null && finalBooking.customerName!.isNotEmpty)
              ? finalBooking.customerName!
              : "A patient";
      final serviceName =
          (finalBooking.serviceTitle != null && finalBooking.serviceTitle!.isNotEmpty)
              ? finalBooking.serviceTitle!
              : "a consultation";

      final notification = NotificationModel(
        userId: finalBooking.providerId,
        title: "New Booking Received",
        body: "$patientName booked $serviceName for ${finalBooking.bookingTime}.",
        type: "booking_created",
        relatedId: docRef.id,
        isRead: false,
        createdAt: DateTime.now(),
      );

      try {
        await _firestore
            .collection('notifications')
            .add(notification.toJson());
      } catch (_) {}
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings(String customerId) async {
    final uid = customerId.isNotEmpty
        ? customerId
        : (FirebaseAuth.instance.currentUser?.uid ?? "");

    final querySnapshot = await _firestore
        .collection('bookings')
        .where('customerId', isEqualTo: uid)
        .get();

    final list = querySnapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
        .toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Stream<List<BookingModel>> getUserBookingsStream(String customerId) {
    final uid = customerId.isNotEmpty
        ? customerId
        : (FirebaseAuth.instance.currentUser?.uid ?? "");
    if (uid.isEmpty) return Stream.value([]);

    return _firestore
        .collection('bookings')
        .where('customerId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    }).handleError((_) => <BookingModel>[]);
  }

  @override
  Future<List<BookingModel>> getProviderBookings(String providerId) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = providerId.isNotEmpty
        ? providerId
        : (user?.uid ?? "");
    if (uid.isEmpty) return [];

    final currentName = (user?.displayName ?? '').trim().toLowerCase();

    try {
      final querySnapshot = await _firestore.collection('bookings').get();

      final list = querySnapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
          .where((b) {
            if (b.providerId == uid) return true;
            if (currentName.isNotEmpty) {
              final pName = (b.providerName ?? '').trim().toLowerCase();
              final pId = b.providerId.trim().toLowerCase();
              if (pName == currentName ||
                  pId == currentName ||
                  pName.contains(currentName) ||
                  currentName.contains(pName)) {
                return true;
              }
            }
            return false;
          })
          .toList();

      list.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
      return list;
    } catch (_) {
      return [];
    }
  }

  @override
  Stream<List<BookingModel>> getProviderBookingsStream(String providerId) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = providerId.isNotEmpty
        ? providerId
        : (user?.uid ?? "");
    if (uid.isEmpty) return Stream.value([]);

    final currentName = (user?.displayName ?? '').trim().toLowerCase();

    return _firestore
        .collection('bookings')
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
          .where((b) {
            if (b.providerId == uid) return true;
            if (currentName.isNotEmpty) {
              final pName = (b.providerName ?? '').trim().toLowerCase();
              final pId = b.providerId.trim().toLowerCase();
              if (pName == currentName ||
                  pId == currentName ||
                  pName.contains(currentName) ||
                  currentName.contains(pName)) {
                return true;
              }
            }
            return false;
          })
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    }).handleError((_) => <BookingModel>[]);
  }

  @override
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': newStatus,
    });

    // Notify Customer about status change
    try {
      final bookingDoc =
          await _firestore.collection('bookings').doc(bookingId).get();
      if (bookingDoc.exists) {
        final data = bookingDoc.data();
        if (data != null) {
          final customerId = data['customerId'] as String?;
          final providerName = data['providerName'] as String? ?? "Your provider";
          final serviceTitle = data['serviceTitle'] as String? ?? "service";

          if (customerId != null && customerId.isNotEmpty) {
            String title = "Booking Updated";
            String body = "Your booking status changed to $newStatus.";
            String type = "booking_$newStatus";

            if (newStatus == 'confirmed') {
              title = "Booking Confirmed";
              body = "$providerName accepted your booking for $serviceTitle.";
              type = "booking_confirmed";
            } else if (newStatus == 'cancelled') {
              title = "Booking Cancelled";
              body = "Your booking for $serviceTitle has been cancelled.";
              type = "booking_cancelled";
            } else if (newStatus == 'completed') {
              title = "Appointment Completed";
              body = "Your appointment for $serviceTitle is completed.";
              type = "booking_completed";
            }

            final notification = NotificationModel(
              userId: customerId,
              title: title,
              body: body,
              type: type,
              relatedId: bookingId,
              isRead: false,
              createdAt: DateTime.now(),
            );

            await _firestore
                .collection('notifications')
                .add(notification.toJson());
          }
        }
      }
    } catch (_) {}
  }
}
