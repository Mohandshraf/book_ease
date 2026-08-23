import 'package:book_ease/core/di/service_locator.dart';
import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_theme.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/provider_availability/data/cubit/provider_availability_cubit.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_cubit.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_cubit.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_cubit.dart';
import 'package:book_ease/features/service_details/data/cubit/booking_date_cubit.dart';
import 'package:book_ease/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<UserCubit>(create: (_) => sl<UserCubit>()),
        BlocProvider<BookingCubit>(create: (_) => sl<BookingCubit>()),
        BlocProvider<BookingSelectionCubit>(
          create: (_) => sl<BookingSelectionCubit>(),
        ),
        BlocProvider<ChatCubit>(create: (_) => sl<ChatCubit>()),
        BlocProvider<NotificationCubit>(
          create: (_) => sl<NotificationCubit>(),
        ),
        BlocProvider<ProviderBookingsCubit>(
          create: (_) => sl<ProviderBookingsCubit>(),
        ),
        BlocProvider<ProviderServicesCubit>(
          create: (_) => sl<ProviderServicesCubit>(),
        ),
        BlocProvider<ProviderAvailabilityCubit>(
          create: (_) => sl<ProviderAvailabilityCubit>(),
        ),
        BlocProvider<ProviderDashboardCubit>(
          create: (_) => sl<ProviderDashboardCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
