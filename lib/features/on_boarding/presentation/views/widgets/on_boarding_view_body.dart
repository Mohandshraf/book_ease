import 'package:book_ease/features/login/presentation/views/login_view.dart';
import 'package:book_ease/features/onBoarding/data/models/on_boarding_model.dart';
import 'package:book_ease/features/onBoarding/presentation/views/on_boarding_page.dart';
import 'package:flutter/material.dart';

class OnBoardingPageViewBody extends StatefulWidget {
  const OnBoardingPageViewBody({super.key});

  @override
  State<OnBoardingPageViewBody> createState() => _OnBoardingPageViewBodyState();
}

class _OnBoardingPageViewBodyState extends State<OnBoardingPageViewBody> {
  int currentPage = 0;

  final pages = [
    OnBoardingModel(
      image: "assets/images/image1.png",
      title: "Book Appointments Anytime, Anywhere",
      description:
          "Access hundreds of top-rated providers and lock in your exact slot in seconds — any hour, any day.",
      buttonText: "Next",
      backgroundColor: Color(0xffebfcf4),
      bottonColor: Color(0xff059668),
    ),
    OnBoardingModel(
      image: "assets/images/image2.png",
      title: "Skip Waiting Queues Forever",
      description:
          "Reserve your exact slot and walk in right on time. No more wasted hours sitting in a waiting room.",
      buttonText: "Next",
      backgroundColor: Color(0xfffffbeb),
      bottonColor: Color(0xffd97707),
    ),
    OnBoardingModel(
      image: "assets/images/image3.png",
      title: "Manage Everything With Ease",
      description:
          "Track upcoming appointments, review past visits, and get smart reminders — all in one beautiful place.",
      buttonText: "Get Started",
      backgroundColor: Color(0xfff0f9ff),
      bottonColor: Color(0xff0790b3),
    ),
  ];

  void nextPage() {
    if (currentPage < pages.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginView();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),

      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },

      child: OnBoardingPage(
        key: ValueKey(currentPage),

        image: pages[currentPage].image,
        title: pages[currentPage].title,
        description: pages[currentPage].description,
        buttonText: pages[currentPage].buttonText,
        bottonColor: pages[currentPage].bottonColor,
        backgroundColor: pages[currentPage].backgroundColor,

        currentIndex: currentPage,

        onPressed: nextPage,
      ),
    );
  }
}
