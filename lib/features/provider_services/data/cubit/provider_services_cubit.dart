import 'dart:async';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_state.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderServicesCubit extends Cubit<ProviderServicesState> {
  final ProviderServicesRepo _servicesRepo;
  StreamSubscription<List<ServiceModel>>? _servicesSubscription;
  List<ServiceModel> _services = [];

  ProviderServicesCubit(this._servicesRepo) : super(ProviderServicesInitial());

  List<ServiceModel> get services => _services;

  void subscribeToServices({String? providerId}) {
    _servicesSubscription?.cancel();
    _services = [];
    emit(ProviderServicesLoading());

    final uid = providerId ?? FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      emit(const ProviderServicesSuccess([]));
      return;
    }

    _servicesSubscription =
        _servicesRepo.getProviderServicesStream(uid).listen(
      (services) {
        _services = services;
        emit(ProviderServicesSuccess(_services));
      },
      onError: (error) {
        emit(ProviderServicesError(error.toString()));
      },
    );
  }

  Future<void> fetchServices({String? providerId}) async {
    _servicesSubscription?.cancel();
    _services = [];
    emit(ProviderServicesLoading());

    try {
      final uid = providerId ?? FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        emit(const ProviderServicesSuccess([]));
        return;
      }
      final services = await _servicesRepo.getProviderServices(uid);
      _services = services;
      emit(ProviderServicesSuccess(_services));
    } catch (e) {
      emit(ProviderServicesError(e.toString()));
    }
  }

  Future<void> addService(ServiceModel service) async {
    try {
      await _servicesRepo.addService(service);
      emit(ProviderServiceActionSuccess("Service added successfully"));
      if (_servicesSubscription == null) {
        await fetchServices(providerId: service.providerId);
      }
    } catch (e) {
      emit(ProviderServicesError(e.toString()));
    }
  }

  Future<void> updateService(ServiceModel service) async {
    try {
      await _servicesRepo.updateService(service);
      emit(ProviderServiceActionSuccess("Service updated successfully"));
      if (_servicesSubscription == null) {
        await fetchServices(providerId: service.providerId);
      }
    } catch (e) {
      emit(ProviderServicesError(e.toString()));
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await _servicesRepo.deleteService(serviceId);
      emit(ProviderServiceActionSuccess("Service deleted successfully"));
      if (_servicesSubscription == null) {
        await fetchServices();
      }
    } catch (e) {
      emit(ProviderServicesError(e.toString()));
    }
  }

  Future<void> toggleActive(String serviceId, bool currentStatus) async {
    try {
      await _servicesRepo.toggleServiceActive(serviceId, !currentStatus);
      // Optimistic update
      final index = _services.indexWhere((s) => s.id == serviceId);
      if (index != -1) {
        _services[index] = _services[index].copyWith(isActive: !currentStatus);
        emit(ProviderServicesSuccess(List.from(_services)));
      }
    } catch (e) {
      emit(ProviderServicesError(e.toString()));
    }
  }

  void reset() {
    _servicesSubscription?.cancel();
    _servicesSubscription = null;
    _services = [];
    emit(ProviderServicesInitial());
  }

  @override
  Future<void> close() {
    _servicesSubscription?.cancel();
    return super.close();
  }
}
