import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Service',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text('Are you sure you want to delete "${service.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ProviderServicesCubit, ProviderServicesState>(
        listener: (context, state) {
          if (state is ProviderServiceActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          } else if (state is ProviderServicesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

          return Stack(
            children: [
              RefreshIndicator(
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
                    bottom: 120, // generous bottom padding to clear the bottom navigation bar
                  ),
                  children: [
                    // Header Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Services',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Manage clinic offerings & pricing',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        ScaleOnTap(
                          onTap: _openAddDialog,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Summary Banner with integrated Add Service button
                    ProviderServicesSummaryBanner(
                      activeCount: activeCount,
                      totalCount: services.length,
                      onAddNew: _openAddDialog,
                    ),
                    const SizedBox(height: 18),

                    // Service Cards
                    ...services.map(
                      (service) => ProviderServiceCard(
                        service: service,
                        onEdit: _openEditDialog,
                        onDelete: _confirmDelete,
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Action Pill Button - positioned safely above the bottom navigation bar
              Positioned(
                bottom: 96,
                right: 20,
                child: ScaleOnTap(
                  onTap: _openAddDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Add Service',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
