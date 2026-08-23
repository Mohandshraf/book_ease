import 'dart:async';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_state.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderDashboardCubit extends Cubit<ProviderDashboardState> {
  final BookingRepo _bookingRepo;
  final ProviderServicesRepo _servicesRepo;
  StreamSubscription<List<BookingModel>>? _bookingsSubscription;

  ProviderDashboardCubit(this._bookingRepo, this._servicesRepo)
      : super(ProviderDashboardInitial());

  void loadDashboardData({String? providerId}) {
    emit(ProviderDashboardLoading());
    final uid = providerId ?? FirebaseAuth.instance.currentUser?.uid ?? '';

    _bookingsSubscription?.cancel();
    _bookingsSubscription = _bookingRepo.getProviderBookingsStream(uid).listen(
      (bookings) async {
        try {
          int activeServicesCount = 0;
          try {
            final services = await _servicesRepo.getProviderServices(uid);
            activeServicesCount = services.where((s) => s.isActive).length;
          } catch (_) {}

          final now = DateTime.now();
          final startOfToday = DateTime(now.year, now.month, now.day);
          final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

          int todayCount = 0;
          int pendingCount = 0;
          int confirmedCount = 0;
          int completedCount = 0;
          double earnings = 0.0;
          List<BookingModel> upcoming = [];

          for (final b in bookings) {
            final status = b.status.toLowerCase();
            if (status == 'pending') pendingCount++;
            if (status == 'confirmed') confirmedCount++;
            if (status == 'completed') {
              completedCount++;
              earnings += (b.price ?? 50.0);
            }

            final bDate = b.bookingDate;
            if (bDate.isAfter(startOfToday.subtract(const Duration(seconds: 1))) &&
                bDate.isBefore(endOfToday.add(const Duration(seconds: 1)))) {
              if (status != 'cancelled' && status != 'rejected') {
                todayCount++;
              }
            }

            if (status == 'confirmed' || status == 'pending') {
              upcoming.add(b);
            }
          }

          upcoming.sort((a, b) => a.bookingDate.compareTo(b.bookingDate));

          final stats = ProviderDashboardStats(
            todayAppointments: todayCount,
            pendingRequests: pendingCount,
            confirmedBookings: confirmedCount,
            completedBookings: completedCount,
            totalEarnings: earnings,
            upcomingBookings: upcoming.take(5).toList(),
            activeServicesCount: activeServicesCount,
          );

          emit(ProviderDashboardLoaded(stats));
        } catch (e) {
          emit(ProviderDashboardError(e.toString()));
        }
      },
      onError: (error) {
        emit(ProviderDashboardError(error.toString()));
      },
    );
  }

  void reset() {
    _bookingsSubscription?.cancel();
    _bookingsSubscription = null;
    emit(ProviderDashboardInitial());
  }

  @override
  Future<void> close() {
    _bookingsSubscription?.cancel();
    return super.close();
  }
}
