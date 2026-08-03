import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';

part 'booking_date_state.dart';

class BookingSelectionCubit extends Cubit<BookingSelectionState> {
  BookingSelectionCubit() : super(const BookingSelectionState());

  void selectDate(DateOption date) {
    emit(state.copyWith(selectedDate: date));
  }

  void selectTime(String time) {
    emit(state.copyWith(selectedTime: time));
  }
}
