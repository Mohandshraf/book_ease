import 'package:book_ease/features/discover/presentation/views/widgets/category_pills_list.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/discover_header.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/discover_provider_card.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/popular_searches_card.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/search_input_field.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/service_details_view.dart';
import 'package:flutter/material.dart';

class DiscoverViewBody extends StatefulWidget {
  const DiscoverViewBody({super.key});

  @override
  State<DiscoverViewBody> createState() => _DiscoverViewBodyState();
}

class _DiscoverViewBodyState extends State<DiscoverViewBody> {
  String selectedCategory = "All";

  final List<String> categories = const [
    "All",
    "Family",
    "Dental",
    "Dermatology"
  ];

  final List<String> popularSearches = const [
    "General checkup",
    "Dentist near me",
    "Skin consultation"
  ];

  late final ServiceDetailsModel sarahMitchellModel;
  late final ServiceDetailsModel omarHassanModel;
  late final ServiceDetailsModel mayaPatelModel;

  @override
  void initState() {
    super.initState();
    
    sarahMitchellModel = mockServiceDetails;

    omarHassanModel = ServiceDetailsModel(
      title: "Downtown Dental Clinic",
      providerName: "Dr. Omar Hassan",
      location: "Downtown, 0.8 km",
      rating: 4.9,
      reviewsCount: 284,
      price: 80.0,
      priceUnit: "per session",
      imageUrl: "https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=800",
      aboutText: "Dr. Omar Hassan is an expert dental surgeon with broad experience in dental care, preventive hygiene, implants, and orthodontic services.",
      specialties: const ["Dental Care", "Cosmetic Dentistry", "Oral Health"],
      availableDates: mockServiceDetails.availableDates,
      availableTimes: mockServiceDetails.availableTimes,
    );

    mayaPatelModel = ServiceDetailsModel(
      title: "Elite Skin Center",
      providerName: "Dr. Maya Patel",
      location: "Downtown, 0.8 km",
      rating: 4.9,
      reviewsCount: 284,
      price: 80.0,
      priceUnit: "per session",
      imageUrl: "https://images.unsplash.com/photo-1594824813573-246434de83fb?auto=format&fit=crop&q=80&w=800",
      aboutText: "Dr. Maya Patel is a leading board-certified dermatologist specializing in advanced clinical skincare, dermatological wellness, and anti-aging therapies.",
      specialties: const ["Dermatology", "Skincare Clinic", "Anti-Aging"],
      availableDates: mockServiceDetails.availableDates,
      availableTimes: mockServiceDetails.availableTimes,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> providers = [
      {
        "name": "Dr. Sarah Mitchell",
        "subtitle": "Family Medicine • 0.8 km",
        "rating": "4.9",
        "reviews": "284",
        "price": "From \$80",
        "image": "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=200",
        "model": sarahMitchellModel,
      },
      {
        "name": "Dr. Omar Hassan",
        "subtitle": "Dental Care • 0.8 km",
        "rating": "4.9",
        "reviews": "284",
        "price": "From \$80",
        "image": "https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=200",
        "model": omarHassanModel,
      },
      {
        "name": "Dr. Maya Patel",
        "subtitle": "Dermatology • 0.8 km",
        "rating": "4.9",
        "reviews": "284",
        "price": "From \$80",
        "image": "https://images.unsplash.com/photo-1594824813573-246434de83fb?auto=format&fit=crop&q=80&w=200",
        "model": mayaPatelModel,
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DiscoverHeader(title: "Search"),
            const SizedBox(height: 20),
            const SearchInputField(hintText: "Providers, services, specialties"),
            const SizedBox(height: 20),
            CategoryPillsList(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (cat) {
                setState(() {
                  selectedCategory = cat;
                });
              },
            ),
            const SizedBox(height: 20),
            PopularSearchesCard(popularSearches: popularSearches),
            const SizedBox(height: 28),
            const Text(
              "3 PROVIDERS FOUND",
              style: TextStyle(
                color: Color(0xff94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: providers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final p = providers[index];
                final ServiceDetailsModel model = p["model"];
                return DiscoverProviderCard(
                  name: p["name"],
                  subtitle: p["subtitle"],
                  rating: p["rating"],
                  reviews: p["reviews"],
                  price: p["price"],
                  image: p["image"],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetailsView(model: model),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
