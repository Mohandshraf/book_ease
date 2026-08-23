import 'package:book_ease/features/booking/data/models/booking_model.dart';

abstract class BookingRepo {
  Future<void> createBooking(BookingModel booking);
  Future<List<BookingModel>> getUserBookings(String customerId);
  Stream<List<BookingModel>> getUserBookingsStream(String customerId);
  Future<List<BookingModel>> getProviderBookings(String providerId);
  Stream<List<BookingModel>> getProviderBookingsStream(String providerId);
  Future<void> updateBookingStatus(String bookingId, String newStatus);
}
