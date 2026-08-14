class DateOption {
  final String dayName;
  final int dayNumber;
  final DateTime date;

  const DateOption({
    required this.dayName,
    required this.dayNumber,
    required this.date,
  });
}

class ServiceDetailsModel {
  final String title;
  final String providerName;
  final String location;
  final double rating;
  final int reviewsCount;
  final double price;
  final String priceUnit;
  final String imageUrl;
  final String aboutText;
  final List<String> specialties;
  final List<DateOption> availableDates;
  final List<String> availableTimes;

  const ServiceDetailsModel({
    required this.title,
    required this.providerName,
    required this.location,
    required this.rating,
    required this.reviewsCount,
    required this.price,
    required this.priceUnit,
    required this.imageUrl,
    required this.aboutText,
    required this.specialties,
    required this.availableDates,
    required this.availableTimes,
  });
}

List<DateOption> generateDynamicDateOptions([int count = 7]) {
  final now = DateTime.now();
  const dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  return List.generate(count, (i) {
    final date = now.add(Duration(days: i));
    final dayName = dayNames[date.weekday - 1];
    return DateOption(
      dayName: dayName,
      dayNumber: date.day,
      date: DateTime(date.year, date.month, date.day),
    );
  });
}

final ServiceDetailsModel mockServiceDetails = ServiceDetailsModel(
  title: "City Medical Clinic",
  providerName: "Dr. Sarah Mitchell",
  location: "Downtown, 0.8 km",
  rating: 4.9,
  reviewsCount: 284,
  price: 80.0,
  priceUnit: "per session",
  imageUrl:
      "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800",
  aboutText:
      "Dr. Sarah Mitchell is a board-certified physician with over 15 years of experience in family and general medicine, specializing in preventive care and chronic disease management.",
  specialties: const ["General Medicine", "Family Care", "Preventive"],
  availableDates: generateDynamicDateOptions(),
  availableTimes: const [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
    "3:30 PM",
    "4:00 PM",
  ],
);
