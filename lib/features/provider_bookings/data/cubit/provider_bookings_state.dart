import 'package:book_ease/features/booking/data/models/booking_model.dart';

abstract class ProviderBookingsState {}

class ProviderBookingsInitial extends ProviderBookingsState {}

class ProviderBookingsLoading extends ProviderBookingsState {}

class ProviderBookingsSuccess extends ProviderBookingsState {
  final List<BookingModel> allBookings;
  final List<BookingModel> filteredBookings;
  final String activeFilter; // 'all', 'pending', 'confirmed', 'completed', 'cancelled'

  ProviderBookingsSuccess({
    required this.allBookings,
    required this.filteredBookings,
    this.activeFilter = 'all',
  });
}

class ProviderBookingsError extends ProviderBookingsState {
  final String message;
  ProviderBookingsError(this.message);
}

class ProviderBookingActionLoading extends ProviderBookingsState {
  final String bookingId;
  ProviderBookingActionLoading(this.bookingId);
}
