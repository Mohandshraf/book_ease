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
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = const [
    "All",
    "Family",
    "Dental",
    "Dermatology",
  ];

  final List<String> popularSearches = const [
    "General checkup",
    "Dentist near me",
    "Skin consultation",
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
      imageUrl:
          "https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=800",
      aboutText:
          "Dr. Omar Hassan is an expert dental surgeon with broad experience in dental care, preventive hygiene, implants, and orthodontic services.",
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
      imageUrl:
          "https://images.unsplash.com/photo-1594824813573-246434de83fb?auto=format&fit=crop&q=80&w=800",
      aboutText:
          "Dr. Maya Patel is a leading board-certified dermatologist specializing in advanced clinical skincare, dermatological wellness, and anti-aging therapies.",
      specialties: const ["Dermatology", "Skincare Clinic", "Anti-Aging"],
      availableDates: mockServiceDetails.availableDates,
      availableTimes: mockServiceDetails.availableTimes,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allProviders = [
      {
        "name": "Dr. Sarah Mitchell",
        "subtitle": "Family Medicine • 0.8 km",
        "category": "Family",
        "rating": "4.9",
        "reviews": "284",
        "price": "From \$80",
        "image":
            "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=200",
        "model": sarahMitchellModel,
      },
      {
        "name": "Dr. Omar Hassan",
        "subtitle": "Dental Care • 0.8 km",
        "category": "Dental",
        "rating": "4.9",
        "reviews": "284",
        "price": "From \$80",
        "image":
            "https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=200",
        "model": omarHassanModel,
      },
      {
        "name": "Dr. Maya Patel",
        "subtitle": "Dermatology • 0.8 km",
        "category": "Dermatology",
        "rating": "4.9",
        "reviews": "284",
        "price": "From \$80",
        "image":
            "https://images.unsplash.com/photo-1594824813573-246434de83fb?auto=format&fit=crop&q=80&w=200",
        "model": mayaPatelModel,
      },
    ];

    final filteredProviders = allProviders.where((p) {
      final String name = p["name"].toString().toLowerCase();
      final String subtitle = p["subtitle"].toString().toLowerCase();
      final String category = (p["category"] ?? "").toString().toLowerCase();
      final ServiceDetailsModel model = p["model"];
      final String query = searchQuery.trim().toLowerCase();

      final bool matchesCategory =
          selectedCategory == "All" ||
          category == selectedCategory.toLowerCase() ||
          subtitle.contains(selectedCategory.toLowerCase());

      final bool matchesQuery =
          query.isEmpty ||
          name.contains(query) ||
          subtitle.contains(query) ||
          model.title.toLowerCase().contains(query) ||
          model.aboutText.toLowerCase().contains(query) ||
          model.specialties.any((s) => s.toLowerCase().contains(query));

      return matchesCategory && matchesQuery;
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DiscoverHeader(title: "Search"),
            const SizedBox(height: 20),
            SearchInputField(
              hintText: "Providers, services, specialties",
              controller: searchController,
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
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
            PopularSearchesCard(
              popularSearches: popularSearches,
              onSearchTap: (term) {
                setState(() {
                  searchQuery = term;
                  searchController.text = term;
                });
              },
            ),
            const SizedBox(height: 28),
            Text(
              "${filteredProviders.length} PROVIDERS FOUND",
              style: const TextStyle(
                color: Color(0xff94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            if (filteredProviders.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: Color(0xff94A3B8),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "No providers found",
                        style: TextStyle(
                          color: Color(0xff64748B),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProviders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final p = filteredProviders[index];
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
                          builder: (context) =>
                              ServiceDetailsView(model: model),
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
