class RecentBookingModel {
  final String name;
  final String service;
  final String time;
  final double price;
  final String status;

  const RecentBookingModel({
    required this.name,
    required this.service,
    required this.time,
    required this.price,
    required this.status,
  });

  String get initials {
    if (name.isEmpty) return '';
    final List<String> parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

final List<RecentBookingModel> recentBookings = [
  const RecentBookingModel(
    name: "Alex Johnson",
    service: "General Checkup",
    time: "10:30 AM",
    price: 80,
    status: "confirmed",
  ),
  const RecentBookingModel(
    name: "Maria Garcia",
    service: "Premium Haircut",
    time: "11:00 AM",
    price: 35,
    status: "confirmed",
  ),
  const RecentBookingModel(
    name: "Robert Chen",
    service: "Yoga Class",
    time: "12:00 PM",
    price: 25,
    status: "pending",
  ),
  const RecentBookingModel(
    name: "Sarah Kim",
    service: "Manicure",
    time: "2:30 PM",
    price: 65,
    status: "confirmed",
  ),
];
