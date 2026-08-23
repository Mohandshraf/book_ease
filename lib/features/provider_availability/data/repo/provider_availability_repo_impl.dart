import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/provider_availability/data/models/provider_availability_model.dart';
import 'package:book_ease/features/provider_availability/data/repo/provider_availability_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProviderAvailabilityRepoImpl implements ProviderAvailabilityRepo {
  final FirebaseFirestore _firestore;

  ProviderAvailabilityRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<ProviderAvailabilityModel> getAvailability(String providerId) async {
    if (providerId.isEmpty) {
      return ProviderAvailabilityModel(providerId: '');
    }

    try {
      final doc = await _firestore.collection('availabilities').doc(providerId).get();
      if (doc.exists && doc.data() != null) {
        return ProviderAvailabilityModel.fromJson(doc.data()!, doc.id);
      }
    } catch (_) {}

    return ProviderAvailabilityModel(providerId: providerId);
  }

  @override
  Future<void> saveAvailability(ProviderAvailabilityModel availability) async {
    if (availability.providerId.isEmpty) return;

    await _firestore
        .collection('availabilities')
        .doc(availability.providerId)
        .set(availability.toJson(), SetOptions(merge: true));
  }

  @override
  Future<List<String>> getAvailableSlotsForDate(
    String providerId,
    DateTime date,
  ) async {
    final availability = await getAvailability(providerId);
    if (!availability.isAvailable) return [];

    final dayName = DateFormat('EEEE').format(date); // e.g. 'Monday'
    final isWorkingDay = availability.workingDays.any(
      (d) => d.toLowerCase() == dayName.toLowerCase() ||
             d.toLowerCase().startsWith(dayName.substring(0, 3).toLowerCase()),
    );

    if (!isWorkingDay) return [];

    // Query active bookings on that date to prevent double-booking
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection('bookings')
        .where('providerId', isEqualTo: providerId)
        .get();

    final bookedSlots = <String>{};
    for (final doc in snapshot.docs) {
      final booking = BookingModel.fromJson(doc.data(), doc.id);
      if (booking.status.toLowerCase() != 'cancelled' &&
          booking.status.toLowerCase() != 'rejected') {
        final bDate = booking.bookingDate;
        if (bDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            bDate.isBefore(endOfDay.add(const Duration(seconds: 1)))) {
          bookedSlots.add(booking.bookingTime.trim());
        }
      }
    }

    return availability.slots
        .where((slot) => !bookedSlots.contains(slot.trim()))
        .toList();
  }
}
