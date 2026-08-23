import 'package:book_ease/features/provider_services/data/models/service_model.dart';

abstract class ProviderServicesState {}

class ProviderServicesInitial extends ProviderServicesState {}

class ProviderServicesLoading extends ProviderServicesState {}

class ProviderServicesSuccess extends ProviderServicesState {
  final List<ServiceModel> services;
  ProviderServicesSuccess(this.services);
}

class ProviderServicesError extends ProviderServicesState {
  final String message;
  ProviderServicesError(this.message);
}

class ProviderServiceActionSuccess extends ProviderServicesState {
  final String message;
  ProviderServiceActionSuccess(this.message);
}
