import 'package:book_ease/features/provider_services/data/models/service_model.dart';

abstract class ProviderServicesRepo {
  Future<List<ServiceModel>> getProviderServices(String providerId);
  Stream<List<ServiceModel>> getProviderServicesStream(String providerId);
  Future<List<ServiceModel>> getAllActiveServices();
  Stream<List<ServiceModel>> getAllActiveServicesStream();
  Future<void> addService(ServiceModel service);
  Future<void> updateService(ServiceModel service);
  Future<void> deleteService(String serviceId);
  Future<void> toggleServiceActive(String serviceId, bool isActive);
}
