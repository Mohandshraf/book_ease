import 'dart:async';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderBookingsCubit extends Cubit<ProviderBookingsState> {
  final BookingRepo _bookingRepo;
  StreamSubscription<List<BookingModel>>? _bookingsSubscription;
  List<BookingModel> _allBookings = [];
  String _currentFilter = 'all';

  ProviderBookingsCubit(this._bookingRepo) : super(ProviderBookingsInitial());

  String get currentFilter => _currentFilter;

  void fetchProviderBookings({String? providerId}) async {
    emit(ProviderBookingsLoading());
    try {
      final uid = providerId ?? FirebaseAuth.instance.currentUser?.uid ?? '';
      final bookings = await _bookingRepo.getProviderBookings(uid);
      _allBookings = bookings;
      _applyFilter();
    } catch (e) {
      emit(ProviderBookingsError(e.toString()));
    }
  }

  void subscribeToProviderBookings({String? providerId}) {
    emit(ProviderBookingsLoading());
    final uid = providerId ?? FirebaseAuth.instance.currentUser?.uid ?? '';
    _bookingsSubscription?.cancel();
    _bookingsSubscription = _bookingRepo.getProviderBookingsStream(uid).listen(
      (bookings) {
        _allBookings = bookings;
        _applyFilter();
      },
      onError: (error) {
        emit(ProviderBookingsError(error.toString()));
      },
    );
  }

  void filterByStatus(String status) {
    _currentFilter = status;
    _applyFilter();
  }

  void _applyFilter() {
    List<BookingModel> filtered;
    if (_currentFilter == 'all') {
      filtered = List.from(_allBookings);
    } else {
      filtered = _allBookings
          .where((b) => b.status.toLowerCase() == _currentFilter.toLowerCase())
          .toList();
    }
    emit(ProviderBookingsSuccess(
      allBookings: _allBookings,
      filteredBookings: filtered,
      activeFilter: _currentFilter,
    ));
  }

  Future<void> acceptBooking(String bookingId) async {
    await updateStatus(bookingId, 'confirmed');
  }

  Future<void> rejectBooking(String bookingId) async {
    await updateStatus(bookingId, 'cancelled');
  }

  Future<void> completeBooking(String bookingId) async {
    await updateStatus(bookingId, 'completed');
  }

  Future<void> updateStatus(String bookingId, String newStatus) async {
    try {
      await _bookingRepo.updateBookingStatus(bookingId, newStatus);
      // Optimistic or wait for stream
      final index = _allBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _allBookings[index] = _allBookings[index].copyWith(status: newStatus);
        _applyFilter();
      }
    } catch (e) {
      emit(ProviderBookingsError(e.toString()));
    }
  }

  void reset() {
    _bookingsSubscription?.cancel();
    _bookingsSubscription = null;
    _allBookings = [];
    _currentFilter = 'all';
    emit(ProviderBookingsInitial());
  }

  @override
  Future<void> close() {
    _bookingsSubscription?.cancel();
    return super.close();
  }
}
