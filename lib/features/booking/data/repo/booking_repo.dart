import 'package:book_ease/features/booking/data/models/booking_model.dart';

abstract class BookingRepo {
  Future<void> createBooking(BookingModel booking);
  Future<List<BookingModel>> getUserBookings(String customerId);
}
