import 'package:book_ease/core/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditProfileAvatarPicker extends StatelessWidget {
  final String? selectedPhotoUrl;
  final String userName;
  final VoidCallback onChangePhotoPressed;

  const EditProfileAvatarPicker({
    super.key,
    required this.selectedPhotoUrl,
    required this.userName,
    required this.onChangePhotoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xff0B9B7B),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff0B9B7B).withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: UserAvatar(
                  imageUrl: selectedPhotoUrl,
                  name: userName,
                  radius: 54,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onChangePhotoPressed,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xff0B9B7B),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        TextButton.icon(
          onPressed: onChangePhotoPressed,
          icon: const Icon(
            Icons.edit_outlined,
            size: 16,
            color: Color(0xff0B9B7B),
          ),
          label: const Text(
            "Change Profile Photo",
            style: TextStyle(
              color: Color(0xff0B9B7B),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
