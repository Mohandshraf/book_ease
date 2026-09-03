import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/on_boarding/data/models/on_boarding_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.model,
  });

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // Illustration Container with Soft Accent & Shadows
          FadeSlideTransition(
            delay: const Duration(milliseconds: 150),
            child: Container(
              width: double.infinity,
              height: size.height * 0.44,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative subtle background glow
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary.withValues(alpha: 0.06),
                      ),
                    ),
                  ),

                  // The Main Image Illustration
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Image.asset(
                      model.image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(flex: 2),

          // Title
          FadeSlideTransition(
            delay: const Duration(milliseconds: 250),
            child: Text(
              context.tr(model.titleKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.6,
                height: 1.3,
              ),
            ),
          ),

          const Gap(14),

          // Description
          FadeSlideTransition(
            delay: const Duration(milliseconds: 350),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                context.tr(model.descKey),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
