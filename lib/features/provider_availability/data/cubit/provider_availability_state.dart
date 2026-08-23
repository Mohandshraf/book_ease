import 'package:book_ease/features/provider_availability/data/models/provider_availability_model.dart';

abstract class ProviderAvailabilityState {}

class ProviderAvailabilityInitial extends ProviderAvailabilityState {}

class ProviderAvailabilityLoading extends ProviderAvailabilityState {}

class ProviderAvailabilityLoaded extends ProviderAvailabilityState {
  final ProviderAvailabilityModel availability;
  ProviderAvailabilityLoaded(this.availability);
}

class ProviderAvailabilitySaving extends ProviderAvailabilityState {
  final ProviderAvailabilityModel availability;
  ProviderAvailabilitySaving(this.availability);
}

class ProviderAvailabilitySavedSuccess extends ProviderAvailabilityState {
  final ProviderAvailabilityModel availability;
  final String message;
  ProviderAvailabilitySavedSuccess(this.availability, {this.message = "Availability saved successfully"});
}

class ProviderAvailabilityError extends ProviderAvailabilityState {
  final String message;
  ProviderAvailabilityError(this.message);
}
