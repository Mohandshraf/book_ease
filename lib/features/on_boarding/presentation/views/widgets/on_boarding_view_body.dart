import 'package:book_ease/core/di/service_locator.dart';
import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/services/app_preferences.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/on_boarding/data/models/on_boarding_model.dart';
import 'package:book_ease/features/on_boarding/presentation/views/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OnBoardingPageViewBody extends StatefulWidget {
  const OnBoardingPageViewBody({super.key});

  @override
  State<OnBoardingPageViewBody> createState() => _OnBoardingPageViewBodyState();
}

class _OnBoardingPageViewBodyState extends State<OnBoardingPageViewBody> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnBoardingModel> _pages = const [
    OnBoardingModel(
      image: 'assets/images/image1.png',
      titleKey: 'onboarding_title_1',
      descKey: 'onboarding_desc_1',
    ),
    OnBoardingModel(
      image: 'assets/images/image2.png',
      titleKey: 'onboarding_title_2',
      descKey: 'onboarding_desc_2',
    ),
    OnBoardingModel(
      image: 'assets/images/image3.png',
      titleKey: 'onboarding_title_3',
      descKey: 'onboarding_desc_3',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await sl<AppPreferences>().setOnboardingSeen(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == _pages.length - 1;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar (Logo Brand Badge & Skip Button)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BookEase Logo Brand Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.local_hospital_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        Gap(6),
                        Text(
                          "BookEase",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Skip Button (faded / hidden on the last page)
                  AnimatedOpacity(
                    opacity: isLastPage ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: isLastPage,
                      child: TextButton(
                        onPressed: _completeOnboarding,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          context.tr('onboarding_skip'),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main PageView with 3 Onboarding Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return OnBoardingPage(model: _pages[index]);
                },
              ),
            ),

            // Bottom Bar: Dots Indicators & Primary Next / Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Smooth Expanding Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isSelected = _currentIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 7,
                        width: isSelected ? 28 : 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),

                  const Gap(24),

                  // Main Action Button (Next or Get Started)
                  ScaleOnTap(
                    onTap: _onNext,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.32),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLastPage
                                ? context.tr('onboarding_get_started')
                                : context.tr('onboarding_next'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const Gap(8),
                          Icon(
                            isLastPage
                                ? Icons.check_circle_outline_rounded
                                : (isRtl
                                    ? Icons.arrow_back_rounded
                                    : Icons.arrow_forward_rounded),
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
