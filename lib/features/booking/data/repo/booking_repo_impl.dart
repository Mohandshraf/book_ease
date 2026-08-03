import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRepoImpl implements BookingRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createBooking(BookingModel booking) async {
    await _firestore.collection('bookings').add(booking.toJson());
  }

  @override
  Future<List<BookingModel>> getUserBookings(String customerId) async {
    final querySnapshot = await _firestore
        .collection('bookings')
        .where('customerId', isEqualTo: customerId)
        .get();

    return querySnapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}
