import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_cubit.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_state.dart';
import 'package:book_ease/features/provider_dashboard/presentation/views/widgets/provider_dashboard_header.dart';
import 'package:book_ease/features/provider_dashboard/presentation/views/widgets/provider_quick_actions.dart';
import 'package:book_ease/features/provider_dashboard/presentation/views/widgets/provider_stats_grid.dart';
import 'package:book_ease/features/provider_dashboard/presentation/views/widgets/provider_upcoming_appointments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderDashboardViewBody extends StatefulWidget {
  final Function(int)? onTabChangeRequested;

  const ProviderDashboardViewBody({super.key, this.onTabChangeRequested});

  @override
  State<ProviderDashboardViewBody> createState() =>
      _ProviderDashboardViewBodyState();
}

class _ProviderDashboardViewBodyState extends State<ProviderDashboardViewBody> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<ProviderDashboardCubit>().loadDashboardData(providerId: uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderDashboardCubit, ProviderDashboardState>(
      builder: (context, state) {
        if (state is ProviderDashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is ProviderDashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                Text(
                  state.message,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                    context
                        .read<ProviderDashboardCubit>()
                        .loadDashboardData(providerId: uid);
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final stats = state is ProviderDashboardLoaded
            ? state.stats
            : ProviderDashboardStats();

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
            context
                .read<ProviderDashboardCubit>()
                .loadDashboardData(providerId: uid);
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              const ProviderDashboardHeader(),
              const SizedBox(height: 24),
              ProviderStatsGrid(stats: stats),
              const SizedBox(height: 24),
              ProviderQuickActions(
                onTabChangeRequested: widget.onTabChangeRequested,
              ),
              const SizedBox(height: 28),
              ProviderUpcomingAppointments(
                bookings: stats.upcomingBookings,
                onTabChangeRequested: widget.onTabChangeRequested,
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
