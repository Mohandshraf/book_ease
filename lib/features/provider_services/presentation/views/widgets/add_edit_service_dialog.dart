import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_cubit.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditServiceDialog extends StatefulWidget {
  final ServiceModel? existingService;

  const AddEditServiceDialog({super.key, this.existingService});

  @override
  State<AddEditServiceDialog> createState() => _AddEditServiceDialogState();
}

class _AddEditServiceDialogState extends State<AddEditServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;
  late TextEditingController _descriptionController;
  late String _priceUnit;
  late bool _isActive;

  final List<String> _categories = [
    'Cardiology',
    'Dermatology',
    'Dentistry',
    'General Consultation',
    'Neurology',
    'Pediatrics',
    'Orthopedics',
    'Psychiatry',
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.existingService;
    _titleController = TextEditingController(text: s?.title ?? '');
    _categoryController =
        TextEditingController(text: s?.category ?? 'General Consultation');
    _priceController =
        TextEditingController(text: s != null ? s.price.toString() : '50.0');
    _durationController = TextEditingController(
        text: s != null ? s.durationMinutes.toString() : '45');
    _descriptionController = TextEditingController(text: s?.description ?? '');
    _priceUnit = s?.priceUnit ?? '/session';
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';
    final userCubitState = context.read<UserCubit>().state;
    String name = user?.displayName ?? 'Doctor';
    if (userCubitState is UserDataLoaded) {
      final dbName = userCubitState.userData['name'] as String?;
      if (dbName != null && dbName.trim().isNotEmpty) {
        name = dbName.trim();
      }
    }

    final service = ServiceModel(
      id: widget.existingService?.id,
      providerId: widget.existingService?.providerId ?? uid,
      providerName: widget.existingService?.providerName ?? name,
      title: _titleController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      priceUnit: _priceUnit,
      durationMinutes: int.tryParse(_durationController.text.trim()) ?? 45,
      description: _descriptionController.text.trim(),
      isActive: _isActive,
      createdAt: widget.existingService?.createdAt ?? DateTime.now(),
    );

    if (widget.existingService == null) {
      context.read<ProviderServicesCubit>().addService(service);
    } else {
      context.read<ProviderServicesCubit>().updateService(service);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingService != null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 480),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Service' : 'Add New Service',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Service Title *',
                    hintText: 'e.g. Comprehensive Heart Checkup',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 14),

                // Category dropdown / field
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _categories.contains(_categoryController.text)
                      ? _categoryController.text
                      : _categories.first,
                  decoration: InputDecoration(
                    labelText: 'Specialty / Category',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _categoryController.text = val;
                    }
                  },
                ),
                const SizedBox(height: 14),

                // Price & Unit
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Price (\$) *',
                          prefixText: '\$ ',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _priceUnit,
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: '/session',
                            child: Text(
                              '/session',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          DropdownMenuItem(
                            value: '/hr',
                            child: Text(
                              '/hr',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          DropdownMenuItem(
                            value: '/visit',
                            child: Text(
                              '/visit',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _priceUnit = val;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Duration
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Duration (minutes)',
                    suffixText: 'mins',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Service Description',
                    hintText: 'Describe what is included in this service...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Active Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active & Available',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Visible for client bookings',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isActive,
                      activeTrackColor: AppColors.primaryLight,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {
                          _isActive = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 3,
                      shadowColor: AppColors.primary.withValues(alpha: 0.35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      isEditing ? 'Save Changes' : 'Create Service',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
