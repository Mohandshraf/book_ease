import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _dotsController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _dotsFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat();

    _logoScale = Tween<double>(begin: .78, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, .58, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, .45, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<double>(begin: 26, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.28, .78, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.28, .78, curve: Curves.easeOut),
      ),
    );

    _dotsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.66, 1, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    final minimumSplashTimer = Future.delayed(const Duration(seconds: 2));

    if (FirebaseAuth.instance.currentUser == null) {
      await minimumSplashTimer;
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onBoarding);
      return;
    }

    final userCubit = context.read<UserCubit>();
    await Future.wait([
      userCubit.getCurrentUserData(),
      minimumSplashTimer,
    ]);

    if (!mounted) return;

    final state = userCubit.state;
    if (state is UserDataLoaded) {
      final role = state.userData['role'];
      if (role == 'provider') {
        Navigator.pushReplacementNamed(context, AppRoutes.providerRoot);
      } else if (role == 'customer') {
        Navigator.pushReplacementNamed(context, AppRoutes.customerRoot);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.chooseRole);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onBoarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryGradientStart,
                AppColors.primary,
                AppColors.primaryGradientEnd,
              ],
            ),
          ),
          child: Stack(
            children: [
              const Positioned(
                top: -118,
                right: -92,
                child: _SoftCircle(size: 310, opacity: .08),
              ),
              const Positioned(
                top: 104,
                left: -100,
                child: _SoftCircle(size: 220, opacity: .06),
              ),
              const Positioned(
                bottom: -80,
                left: 60,
                child: _SoftCircle(size: 260, opacity: .05),
              ),
              Center(
                child: Transform.translate(
                  offset: const Offset(0, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Opacity(
                        opacity: _logoFade.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: const _BookEaseLogo(),
                        ),
                      ),
                      const SizedBox(height: 34),
                      Opacity(
                        opacity: _titleFade.value,
                        child: Transform.translate(
                          offset: Offset(0, _titleSlide.value),
                          child: const Column(
                            children: [
                              Text(
                                'BookEase',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 44,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'BOOK SMARTER · LIVE BETTER',
                                style: TextStyle(
                                  color: AppColors.accentLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Opacity(
                        opacity: _dotsFade.value,
                        child: _LoadingDots(controller: _dotsController),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BookEaseLogo extends StatelessWidget {
  const _BookEaseLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: Colors.white.withValues(alpha: .22), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .20),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 66,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 14,
                left: 0,
                right: 0,
                child: Container(height: 2, color: AppColors.border),
              ),
              const Positioned(top: -3, left: 14, child: _BinderDot()),
              const Positioned(top: -3, right: 14, child: _BinderDot()),
              const Positioned(
                left: 14,
                top: 24,
                child: _LogoDot(active: true),
              ),
              const Positioned(left: 28, top: 24, child: _LogoDot()),
              const Positioned(left: 42, top: 24, child: _LogoDot()),
              const Positioned(left: 14, top: 38, child: _LogoDot()),
              const Positioned(
                left: 28,
                top: 38,
                child: _LogoDot(active: true),
              ),
              const Positioned(left: 42, top: 38, child: _LogoDot()),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;

            double value = ((controller.value - delay + 1) % 1);

            final translateY = -10 * (1 - (value * 2 - 1).abs());

            return Transform.translate(
              offset: Offset(0, translateY),
              child: Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .9),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _BinderDot extends StatelessWidget {
  const _BinderDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _LogoDot extends StatelessWidget {
  const _LogoDot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.accentLight,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

