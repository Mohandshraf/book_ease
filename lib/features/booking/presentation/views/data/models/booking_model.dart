import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String customerId;
  final String providerId;
  final String serviceId;
  final DateTime bookingDate;
  final String bookingTime;
  final String status;
  final DateTime createdAt;
  BookingModel({
    required this.customerId,
    required this.providerId,
    required this.serviceId,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
    required this.createdAt,
  });
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      customerId: json['customerId'],
      providerId: json['providerId'],
      serviceId: json['serviceId'],
      bookingDate: (json['bookingDate'] as Timestamp).toDate(),
      bookingTime: json['bookingTime'],
      status: json['status'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "providerId": providerId,
      "serviceId": serviceId,
      "bookingDate": bookingDate,
      "bookingTime": bookingTime,
      "status": status,
      "createdAt": createdAt,
    };
  }
}
