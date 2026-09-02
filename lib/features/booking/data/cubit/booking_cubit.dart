import 'package:book_ease/features/booking/data/cubit/booking_state.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this.bookingRepo) : super(BookingInitial());

  final BookingRepo bookingRepo;

  Future<void> createBooking(BookingModel booking) async {
    emit(BookingLoading());

    try {
      await bookingRepo.createBooking(booking);
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> getUserBookings(String customerId) async {
    emit(BookingLoading());

    try {
      final bookings = await bookingRepo.getUserBookings(customerId);
      emit(BookingSuccess(bookings: bookings));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> cancelBooking(String bookingId, String customerId) async {
    emit(BookingLoading());

    try {
      await bookingRepo.updateBookingStatus(bookingId, 'cancelled');
      final bookings = await bookingRepo.getUserBookings(customerId);
      emit(BookingSuccess(bookings: bookings));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}
