import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsDialog extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CredentialsDialog({super.key, required this.userData});

  static Future<void> show(
      BuildContext context, Map<String, dynamic> userData) {
    return showDialog(
      context: context,
      builder: (_) => CredentialsDialog(userData: userData),
    );
  }

  @override
  State<CredentialsDialog> createState() => _CredentialsDialogState();
}

class _CredentialsDialogState extends State<CredentialsDialog> {
  late final TextEditingController _specialtyController;
  late final TextEditingController _licenseController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _specialtyController = TextEditingController(
      text: widget.userData['specialties'] ?? 'General Medicine',
    );
    _licenseController = TextEditingController(
      text: widget.userData['license'] ?? 'MD-928472-EGY',
    );
    _bioController = TextEditingController(
      text: widget.userData['bio'] ?? '',
    );
  }

  @override
  void dispose() {
    _specialtyController.dispose();
    _licenseController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Professional Credentials',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _specialtyController,
              decoration: InputDecoration(
                labelText: 'Primary Specialty',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _licenseController,
              decoration: InputDecoration(
                labelText: 'Medical License / ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Professional Bio & Experience',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            final uid = FirebaseAuth.instance.currentUser?.uid;
            if (uid != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({
                'specialties': _specialtyController.text.trim(),
                'license': _licenseController.text.trim(),
                'bio': _bioController.text.trim(),
              });
              if (!context.mounted) return;
              context.read<UserCubit>().getCurrentUserData();
            }
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
