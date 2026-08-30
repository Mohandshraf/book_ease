import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
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
                    color: AppColors.primary,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
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
                child: ScaleOnTap(
                  onTap: onChangePhotoPressed,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor.withValues(alpha: 0.15),
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
        ScaleOnTap(
          onTap: onChangePhotoPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                Gap(6),
                Text(
                  "Change Profile Photo",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
