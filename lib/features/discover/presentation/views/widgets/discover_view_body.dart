import 'dart:async';
import 'package:book_ease/core/di/service_locator.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/category_pills_list.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/discover_header.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/discover_provider_card.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/popular_searches_card.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/search_input_field.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
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
    "General Consultation",
    "Cardiology",
  ];

  final List<String> popularSearches = const [
    "General checkup",
    "Dentist near me",
    "Skin consultation",
  ];

  List<ServiceModel> _firestoreServices = [];
  StreamSubscription<List<ServiceModel>>? _servicesSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToFirestoreServices();
  }

  void _subscribeToFirestoreServices() {
    try {
      final repo = sl<ProviderServicesRepo>();
      _servicesSubscription = repo.getAllActiveServicesStream().listen(
        (services) {
          if (mounted) {
            setState(() {
              _firestoreServices = services;
            });
          }
        },
        onError: (_) {},
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _servicesSubscription?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allProviders = _firestoreServices.map((s) {
      final dynamicModel = ServiceDetailsModel(
        serviceId: s.id ?? s.title,
        providerId: s.providerId,
        providerImage: s.providerImage,
        title: s.title,
        providerName: s.providerName ?? "Specialist Provider",
        location: "Cairo Clinic • 1.2 km",
        rating: s.rating,
        reviewsCount: s.reviewsCount,
        price: s.price,
        priceUnit: s.priceUnit,
        imageUrl: (s.imageUrl != null && s.imageUrl!.isNotEmpty)
            ? s.imageUrl!
            : "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=800",
        aboutText: s.description.isNotEmpty
            ? s.description
            : "Experienced specialist providing top-tier professional consultations.",
        specialties: s.specialties.isNotEmpty
            ? s.specialties
            : [s.category, "Consultation", "Care"],
        availableDates: mockServiceDetails.availableDates,
        availableTimes: mockServiceDetails.availableTimes,
      );

      return {
        "name": s.providerName ?? "Specialist Provider",
        "subtitle": "${s.category} • 1.2 km",
        "category": s.category,
        "rating": s.rating.toStringAsFixed(1),
        "reviews": s.reviewsCount.toString(),
        "price": "From \$${s.price.toStringAsFixed(0)}",
        "image": (s.imageUrl != null && s.imageUrl!.isNotEmpty)
            ? s.imageUrl!
            : "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=200",
        "model": dynamicModel,
      };
    }).toList();

    final filteredProviders = allProviders.where((p) {
      final String name = p["name"].toString().toLowerCase();
      final String subtitle = p["subtitle"].toString().toLowerCase();
      final String category = (p["category"] ?? "").toString().toLowerCase();
      final ServiceDetailsModel model = p["model"];
      final String query = searchQuery.trim().toLowerCase();

      final bool matchesCategory =
          selectedCategory == "All" ||
          category == selectedCategory.toLowerCase() ||
          subtitle.contains(selectedCategory.toLowerCase()) ||
          model.specialties.any((s) => s.toLowerCase().contains(selectedCategory.toLowerCase()));

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
