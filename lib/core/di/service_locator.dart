import 'package:book_ease/core/services/auth_services.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo_impl.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo_impl.dart';
import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/messages/data/repo/chat_repo.dart';
import 'package:book_ease/features/messages/data/repo/chat_repo_impl.dart';
import 'package:book_ease/features/messages/data/services/chat_services.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/notifications/data/repo/notification_repo.dart';
import 'package:book_ease/features/notifications/data/repo/notification_repo_impl.dart';
import 'package:book_ease/features/notifications/data/services/notification_services.dart';
import 'package:book_ease/features/provider_availability/data/cubit/provider_availability_cubit.dart';
import 'package:book_ease/features/provider_availability/data/repo/provider_availability_repo.dart';
import 'package:book_ease/features/provider_availability/data/repo/provider_availability_repo_impl.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_cubit.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_cubit.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_cubit.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo_impl.dart';
import 'package:book_ease/features/service_details/data/cubit/booking_date_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  sl.registerLazySingleton<ChatServices>(() => ChatServices());
  sl.registerLazySingleton<NotificationServices>(() => NotificationServices());

  // Repositories
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(sl<FirebaseAuthService>()),
  );
  sl.registerLazySingleton<BookingRepo>(() => BookingRepoImpl());
  sl.registerLazySingleton<ChatRepo>(() => ChatRepoImpl(sl<ChatServices>()));
  sl.registerLazySingleton<NotificationRepo>(() => NotificationRepoImpl(sl<NotificationServices>()));
  sl.registerLazySingleton<ProviderServicesRepo>(() => ProviderServicesRepoImpl());
  sl.registerLazySingleton<ProviderAvailabilityRepo>(() => ProviderAvailabilityRepoImpl());

  // Cubits / Blocs (Factories so new instances can be provided or injected)
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepo>()));
  sl.registerFactory<UserCubit>(() => UserCubit(sl<AuthRepo>()));
  sl.registerFactory<BookingCubit>(() => BookingCubit(sl<BookingRepo>()));
  sl.registerFactory<BookingSelectionCubit>(() => BookingSelectionCubit());
  sl.registerFactory<ChatCubit>(() => ChatCubit(sl<ChatRepo>()));
  sl.registerFactory<NotificationCubit>(() => NotificationCubit(sl<NotificationRepo>()));
  sl.registerFactory<ProviderBookingsCubit>(() => ProviderBookingsCubit(sl<BookingRepo>()));
  sl.registerFactory<ProviderServicesCubit>(() => ProviderServicesCubit(sl<ProviderServicesRepo>()));
  sl.registerFactory<ProviderAvailabilityCubit>(() => ProviderAvailabilityCubit(sl<ProviderAvailabilityRepo>()));
  sl.registerFactory<ProviderDashboardCubit>(() => ProviderDashboardCubit(sl<BookingRepo>(), sl<ProviderServicesRepo>()));
}
