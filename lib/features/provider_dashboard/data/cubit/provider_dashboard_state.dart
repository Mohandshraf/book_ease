import 'package:book_ease/features/booking/data/models/booking_model.dart';

class ProviderDashboardStats {
  final int todayAppointments;
  final int pendingRequests;
  final int confirmedBookings;
  final int completedBookings;
  final double totalEarnings;
  final List<BookingModel> upcomingBookings;
  final int activeServicesCount;

  ProviderDashboardStats({
    this.todayAppointments = 0,
    this.pendingRequests = 0,
    this.confirmedBookings = 0,
    this.completedBookings = 0,
    this.totalEarnings = 0.0,
    this.upcomingBookings = const [],
    this.activeServicesCount = 0,
  });
}

abstract class ProviderDashboardState {}

class ProviderDashboardInitial extends ProviderDashboardState {}

class ProviderDashboardLoading extends ProviderDashboardState {}

class ProviderDashboardLoaded extends ProviderDashboardState {
  final ProviderDashboardStats stats;
  ProviderDashboardLoaded(this.stats);
}

class ProviderDashboardError extends ProviderDashboardState {
  final String message;
  ProviderDashboardError(this.message);
}
