import 'package:book_ease/features/provider_services/data/models/service_model.dart';

abstract class ProviderServicesState {
  const ProviderServicesState();
}

class ProviderServicesInitial extends ProviderServicesState {
  const ProviderServicesInitial();
}

class ProviderServicesLoading extends ProviderServicesState {
  const ProviderServicesLoading();
}

class ProviderServicesSuccess extends ProviderServicesState {
  final List<ServiceModel> services;
  const ProviderServicesSuccess(this.services);
}

class ProviderServicesError extends ProviderServicesState {
  final String message;
  const ProviderServicesError(this.message);
}

class ProviderServiceActionSuccess extends ProviderServicesState {
  final String message;
  const ProviderServiceActionSuccess(this.message);
}

