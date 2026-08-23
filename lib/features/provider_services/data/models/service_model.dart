import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String? id;
  final String providerId;
  final String? providerName;
  final String? providerImage;
  final String title;
  final String description;
  final String category;
  final List<String> specialties;
  final double price;
  final String priceUnit;
  final int durationMinutes;
  final String? imageUrl;
  final bool isActive;
  final double rating;
  final int reviewsCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ServiceModel({
    this.id,
    required this.providerId,
    this.providerName,
    this.providerImage,
    required this.title,
    required this.description,
    required this.category,
    this.specialties = const [],
    required this.price,
    this.priceUnit = '/hr',
    this.durationMinutes = 60,
    this.imageUrl,
    this.isActive = true,
    this.rating = 4.9,
    this.reviewsCount = 18,
    required this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    List<String> parseSpecialties(dynamic val) {
      if (val is List) {
        return val.map((e) => e.toString()).toList();
      }
      return [];
    }

    return ServiceModel(
      id: docId ?? json['id'],
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'],
      providerImage: json['providerImage'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      specialties: parseSpecialties(json['specialties']),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceUnit: json['priceUnit'] ?? '/hr',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 60,
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 18,
      createdAt: parseDate(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? parseDate(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      if (providerName != null) "providerName": providerName,
      if (providerImage != null) "providerImage": providerImage,
      "title": title,
      "description": description,
      "category": category,
      if (specialties.isNotEmpty) "specialties": specialties,
      "price": price,
      "priceUnit": priceUnit,
      "durationMinutes": durationMinutes,
      if (imageUrl != null) "imageUrl": imageUrl,
      "isActive": isActive,
      "rating": rating,
      "reviewsCount": reviewsCount,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt ?? DateTime.now()),
    };
  }

  ServiceModel copyWith({
    String? id,
    String? providerId,
    String? providerName,
    String? providerImage,
    String? title,
    String? description,
    String? category,
    List<String>? specialties,
    double? price,
    String? priceUnit,
    int? durationMinutes,
    String? imageUrl,
    bool? isActive,
    double? rating,
    int? reviewsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerImage: providerImage ?? this.providerImage,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      specialties: specialties ?? this.specialties,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
