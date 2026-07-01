import 'package:book_ease/features/home/presentation/views/widgets/category_item.dart';
import 'package:book_ease/features/home/presentation/views/widgets/featured_provider_card.dart';
import 'package:book_ease/features/home/presentation/views/widgets/home_header.dart';
import 'package:book_ease/features/home/presentation/views/widgets/popular_services_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea( 
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HomeHeader(),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Browse Categories",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CategoryItem(
                          title: "Clinic",
                          icon: Icons.medical_services_outlined,
                          color: Color(0xffEAF1FF),
                        ),

                        CategoryItem(
                          title: "Barber",
                          icon: Icons.content_cut,
                          color: Color(0xffFFF5D9),
                        ),

                        CategoryItem(
                          title: "Salon",
                          icon: Icons.auto_awesome,
                          color: Color(0xffFFE5F2),
                        ),

                        CategoryItem(
                          title: "Gym",
                          icon: Icons.fitness_center,
                          color: Color(0xffDDFBF0),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Featured Providers",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),

                        Text(
                          "See all →",
                          style: TextStyle(
                            color: Color(0xff0B9B7B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) => const FeaturedProviderCard(),
                        separatorBuilder: (_, __) => const SizedBox(width: 18),
                        itemCount: 5,
                      ),
                    ),

                    const SizedBox(height: 35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Popular Services",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),

                        Text(
                          "See all →",
                          style: TextStyle(
                            color: Color(0xff0B9B7B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) => const PopularServiceItem(),
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemCount: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
