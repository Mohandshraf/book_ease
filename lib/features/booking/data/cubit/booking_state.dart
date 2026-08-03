import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final List<BookingModel>? bookings;

  BookingSuccess({this.bookings});
}

class BookingFailure extends BookingState {
  final String errorMessage;

  BookingFailure(this.errorMessage);
}
