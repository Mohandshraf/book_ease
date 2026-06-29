import 'package:book_ease/features/onBoarding/presentation/views/on_boarding_view.dart';
import 'package:flutter/material.dart';

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

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnBoardingView()),
      );
    });
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
          color: const Color(0xff0F9B82),
          child: Stack(
            children: [
              const Positioned(
                top: -118,
                right: -92,
                child: _SoftCircle(size: 310, opacity: .12),
              ),
              const Positioned(
                top: 104,
                left: -100,
                child: _SoftCircle(size: 220, opacity: .10),
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
                          child: const _BookBaseLogo(),
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
                                'BookBase',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 45,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -.5,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'BOOK SMARTER · LIVE BETTER',
                                style: TextStyle(
                                  color: Color(0xffBEE7DF),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .4,
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

class _BookBaseLogo extends StatelessWidget {
  const _BookBaseLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: Colors.white.withValues(alpha: .22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .10),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 62,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xffEAF8F5),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 13,
                left: 0,
                right: 0,
                child: Container(height: 2, color: const Color(0xffB8DCD5)),
              ),
              const Positioned(top: -3, left: 14, child: _BinderDot()),
              const Positioned(top: -3, right: 14, child: _BinderDot()),
              const Positioned(
                left: 14,
                top: 24,
                child: _LogoDot(active: true),
              ),
              const Positioned(left: 27, top: 24, child: _LogoDot()),
              const Positioned(left: 40, top: 24, child: _LogoDot()),
              const Positioned(left: 14, top: 38, child: _LogoDot()),
              const Positioned(
                left: 27,
                top: 38,
                child: _LogoDot(active: true),
              ),
              const Positioned(left: 40, top: 38, child: _LogoDot()),
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

            final translateY = -12 * (1 - (value * 2 - 1).abs());

            return Transform.translate(
              offset: Offset(0, translateY),
              child: Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 6),
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
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white,
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
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xff0F9B82) : const Color(0xffA9D9D0),
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
