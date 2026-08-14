import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingRepoImpl implements BookingRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      serviceId: booking.serviceId,
      bookingDate: booking.bookingDate,
      bookingTime: booking.bookingTime,
      status: booking.status,
      createdAt: booking.createdAt,
    );

    await _firestore.collection('bookings').add(finalBooking.toJson());
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

    return querySnapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}
