import 'package:book_ease/features/provider_availability/data/models/provider_availability_model.dart';

abstract class ProviderAvailabilityRepo {
  Future<ProviderAvailabilityModel> getAvailability(String providerId);
  Future<void> saveAvailability(ProviderAvailabilityModel availability);
  Future<List<String>> getAvailableSlotsForDate(String providerId, DateTime date);
}
