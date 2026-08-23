import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_cubit.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_state.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:book_ease/features/provider_services/presentation/views/widgets/add_edit_service_dialog.dart';
import 'package:book_ease/features/provider_services/presentation/views/widgets/provider_service_card.dart';
import 'package:book_ease/features/provider_services/presentation/views/widgets/provider_services_empty_state.dart';
import 'package:book_ease/features/provider_services/presentation/views/widgets/provider_services_summary_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderServicesViewBody extends StatefulWidget {
  const ProviderServicesViewBody({super.key});

  @override
  State<ProviderServicesViewBody> createState() =>
      _ProviderServicesViewBodyState();
}

class _ProviderServicesViewBodyState extends State<ProviderServicesViewBody> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<ProviderServicesCubit>().subscribeToServices(providerId: uid);
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (_) => const AddEditServiceDialog(),
    );
  }

  void _openEditDialog(ServiceModel service) {
    showDialog(
      context: context,
      builder: (_) => AddEditServiceDialog(existingService: service),
    );
  }

  void _confirmDelete(ServiceModel service) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete "${service.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (service.id != null) {
                context
                    .read<ProviderServicesCubit>()
                    .deleteService(service.id!);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _openAddDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Service',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ProviderServicesCubit, ProviderServicesState>(
          listener: (context, state) {
            if (state is ProviderServiceActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is ProviderServicesError) {
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
            if (state is ProviderServicesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final services = context.read<ProviderServicesCubit>().services;

            if (services.isEmpty) {
              return ProviderServicesEmptyState(
                onAddFirstService: _openAddDialog,
              );
            }

            final activeCount = services.where((s) => s.isActive).length;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                context
                    .read<ProviderServicesCubit>()
                    .fetchServices(providerId: uid);
              },
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: 80,
                ),
                children: [
                  ProviderServicesSummaryBanner(
                    activeCount: activeCount,
                    totalCount: services.length,
                    onAddNew: _openAddDialog,
                  ),
                  const SizedBox(height: 16),
                  ...services.map(
                    (service) => ProviderServiceCard(
                      service: service,
                      onEdit: _openEditDialog,
                      onDelete: _confirmDelete,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
