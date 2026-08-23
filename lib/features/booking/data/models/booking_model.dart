import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;
  final String customerId;
  final String? customerName;
  final String? customerEmail;
  final String providerId;
  final String? providerName;
  final String serviceId;
  final String? serviceTitle;
  final double? price;
  final DateTime bookingDate;
  final String bookingTime;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled', 'rejected'
  final DateTime createdAt;
  final String? notes;

  BookingModel({
    this.id,
    required this.customerId,
    this.customerName,
    this.customerEmail,
    required this.providerId,
    this.providerName,
    required this.serviceId,
    this.serviceTitle,
    this.price,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return BookingModel(
      id: docId ?? json['id'],
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'],
      serviceId: json['serviceId'] ?? '',
      serviceTitle: json['serviceTitle'],
      price: (json['price'] as num?)?.toDouble(),
      bookingDate: parseDate(json['bookingDate']),
      bookingTime: json['bookingTime'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: parseDate(json['createdAt']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      if (customerName != null) "customerName": customerName,
      if (customerEmail != null) "customerEmail": customerEmail,
      "providerId": providerId,
      if (providerName != null) "providerName": providerName,
      "serviceId": serviceId,
      if (serviceTitle != null) "serviceTitle": serviceTitle,
      if (price != null) "price": price,
      "bookingDate": Timestamp.fromDate(bookingDate),
      "bookingTime": bookingTime,
      "status": status,
      "createdAt": Timestamp.fromDate(createdAt),
      if (notes != null) "notes": notes,
    };
  }

  BookingModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerEmail,
    String? providerId,
    String? providerName,
    String? serviceId,
    String? serviceTitle,
    double? price,
    DateTime? bookingDate,
    String? bookingTime,
    String? status,
    DateTime? createdAt,
    String? notes,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      serviceId: serviceId ?? this.serviceId,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      price: price ?? this.price,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}
