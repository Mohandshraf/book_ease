import 'package:book_ease/features/SplashView/presentation/views/splash_view.dart';
import 'package:book_ease/features/auth/data/UserCubit/cubit/user_cubit_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo_iplm.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo_impl.dart';
import 'package:book_ease/features/messages/data/cubit/chat_cubit.dart';
import 'package:book_ease/features/messages/data/repo/chat_repo_impl.dart';
import 'package:book_ease/features/service_details/data/cubit/booking_date_cubit.dart';
import 'package:book_ease/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthRepoIplm())),
        BlocProvider(create: (_) => UserCubit(AuthRepoIplm())),
        BlocProvider(create: (_) => BookingCubit(BookingRepoImpl())),
        BlocProvider(create: (_) => BookingSelectionCubit()),
        BlocProvider(create: (_) => ChatCubit(ChatRepoImpl())),
      ],

      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashView(),
      ),
    );
  }
}
