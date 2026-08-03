part of 'booking_date_cubit.dart';

@immutable
class BookingSelectionState {
  final DateOption? selectedDate;
  final String? selectedTime;

  const BookingSelectionState({this.selectedDate, this.selectedTime});

  BookingSelectionState copyWith({
    DateOption? selectedDate,
    String? selectedTime,
  }) {
    return BookingSelectionState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}
