import 'package:book_ease/core/di/service_locator.dart';
import 'package:book_ease/core/services/app_preferences.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/profile/cubit/saved_providers_cubit.dart';
import 'package:book_ease/features/provider_availability/data/cubit/provider_availability_cubit.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_cubit.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_cubit.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppResetHelper {
  static void resetAllUserData(BuildContext context) {
    try {
      sl<AppPreferences>().clearUserRole();
    } catch (_) {}
    try {
      context.read<UserCubit>().clearUserData();
    } catch (_) {}
    try {
      context.read<ProviderServicesCubit>().reset();
    } catch (_) {}
    try {
      context.read<ProviderBookingsCubit>().reset();
    } catch (_) {}
    try {
      context.read<ProviderAvailabilityCubit>().reset();
    } catch (_) {}
    try {
      context.read<ProviderDashboardCubit>().reset();
    } catch (_) {}
    try {
      context.read<BookingCubit>().reset();
    } catch (_) {}
    try {
      context.read<ChatCubit>().reset();
    } catch (_) {}
    try {
      context.read<NotificationCubit>().reset();
    } catch (_) {}
    try {
      context.read<SavedProvidersCubit>().reset();
    } catch (_) {}
  }
}
