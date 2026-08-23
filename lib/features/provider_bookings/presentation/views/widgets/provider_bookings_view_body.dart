import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_cubit.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_state.dart';
import 'package:book_ease/features/provider_bookings/presentation/views/widgets/provider_booking_card.dart';
import 'package:book_ease/features/provider_bookings/presentation/views/widgets/provider_bookings_empty_state.dart';
import 'package:book_ease/features/provider_bookings/presentation/views/widgets/provider_bookings_header_and_filters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderBookingsViewBody extends StatefulWidget {
  const ProviderBookingsViewBody({super.key});

  @override
  State<ProviderBookingsViewBody> createState() =>
      _ProviderBookingsViewBodyState();
}

class _ProviderBookingsViewBodyState extends State<ProviderBookingsViewBody> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _filters = [
    {'label': 'All', 'value': 'all'},
    {'label': 'Pending', 'value': 'pending'},
    {'label': 'Confirmed', 'value': 'confirmed'},
    {'label': 'Completed', 'value': 'completed'},
    {'label': 'Cancelled', 'value': 'cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    context
        .read<ProviderBookingsCubit>()
        .subscribeToProviderBookings(providerId: uid);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ProviderBookingsHeaderAndFilters(
            searchController: _searchController,
            searchQuery: _searchQuery,
            onSearchChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            onClearSearch: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
            filters: _filters,
          ),
          Expanded(
            child: BlocConsumer<ProviderBookingsCubit, ProviderBookingsState>(
              listener: (context, state) {
                if (state is ProviderBookingsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProviderBookingsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is ProviderBookingsSuccess) {
                  var bookings = state.filteredBookings;

                  if (_searchQuery.trim().isNotEmpty) {
                    final q = _searchQuery.toLowerCase();
                    bookings = bookings.where((b) {
                      final name = (b.customerName ?? '').toLowerCase();
                      final service = (b.serviceTitle ?? '').toLowerCase();
                      return name.contains(q) || service.contains(q);
                    }).toList();
                  }

                  if (bookings.isEmpty) {
                    return ProviderBookingsEmptyState(
                      filter: state.activeFilter,
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                      context
                          .read<ProviderBookingsCubit>()
                          .fetchProviderBookings(providerId: uid);
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 14,
                        bottom: 80,
                      ),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        return ProviderBookingCard(booking: bookings[index]);
                      },
                    ),
                  );
                }

                return const ProviderBookingsEmptyState(filter: 'all');
              },
            ),
          ),
        ],
      ),
    );
  }
}
