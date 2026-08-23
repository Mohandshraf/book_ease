import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/provider_availability/data/cubit/provider_availability_cubit.dart';
import 'package:book_ease/features/provider_availability/data/cubit/provider_availability_state.dart';
import 'package:book_ease/features/provider_availability/presentation/views/widgets/appointment_slots_section.dart';
import 'package:book_ease/features/provider_availability/presentation/views/widgets/availability_status_card.dart';
import 'package:book_ease/features/provider_availability/presentation/views/widgets/business_hours_card.dart';
import 'package:book_ease/features/provider_availability/presentation/views/widgets/working_days_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderAvailabilityViewBody extends StatefulWidget {
  const ProviderAvailabilityViewBody({super.key});

  @override
  State<ProviderAvailabilityViewBody> createState() =>
      _ProviderAvailabilityViewBodyState();
}

class _ProviderAvailabilityViewBodyState
    extends State<ProviderAvailabilityViewBody> {
  final List<String> _allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    context
        .read<ProviderAvailabilityCubit>()
        .fetchAvailability(providerId: uid);
  }

  void _showAddSlotDialog() {
    final controller = TextEditingController(text: '09:00 AM');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Time Slot'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Slot e.g. 09:00 AM, 02:30 PM',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context
                    .read<ProviderAvailabilityCubit>()
                    .addSlot(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderAvailabilityCubit, ProviderAvailabilityState>(
      listener: (context, state) {
        if (state is ProviderAvailabilitySavedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is ProviderAvailabilityError) {
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
        final cubit = context.read<ProviderAvailabilityCubit>();
        final model = cubit.currentModel;

        if (state is ProviderAvailabilityLoading && model == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (model == null) {
          return const Center(child: Text("No availability data"));
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AvailabilityStatusCard(
              isAvailable: model.isAvailable,
              onToggle: (val) => cubit.toggleIsAvailable(val),
            ),
            const SizedBox(height: 24),
            WorkingDaysSelector(
              allDays: _allDays,
              selectedDays: model.workingDays,
              onDayToggled: (day) => cubit.toggleDay(day),
            ),
            const SizedBox(height: 24),
            BusinessHoursCard(
              startHour: model.startHour,
              endHour: model.endHour,
            ),
            const SizedBox(height: 24),
            AppointmentSlotsSection(
              slots: model.slots,
              onAddSlot: _showAddSlotDialog,
              onRemoveSlot: (slot) => cubit.removeSlot(slot),
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              onPressed: state is ProviderAvailabilitySaving
                  ? null
                  : () {
                      cubit.saveAvailability(model);
                    },
              child: state is ProviderAvailabilitySaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save Availability Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}
