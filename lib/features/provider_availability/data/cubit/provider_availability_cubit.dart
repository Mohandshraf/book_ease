import 'package:book_ease/features/provider_availability/data/cubit/provider_availability_state.dart';
import 'package:book_ease/features/provider_availability/data/models/provider_availability_model.dart';
import 'package:book_ease/features/provider_availability/data/repo/provider_availability_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderAvailabilityCubit extends Cubit<ProviderAvailabilityState> {
  final ProviderAvailabilityRepo _repo;
  ProviderAvailabilityModel? _currentModel;

  ProviderAvailabilityCubit(this._repo) : super(ProviderAvailabilityInitial());

  ProviderAvailabilityModel? get currentModel => _currentModel;

  Future<void> fetchAvailability({String? providerId}) async {
    emit(ProviderAvailabilityLoading());
    try {
      final uid = providerId ?? FirebaseAuth.instance.currentUser?.uid ?? '';
      final model = await _repo.getAvailability(uid);
      _currentModel = model;
      emit(ProviderAvailabilityLoaded(model));
    } catch (e) {
      emit(ProviderAvailabilityError(e.toString()));
    }
  }

  Future<void> saveAvailability(ProviderAvailabilityModel model) async {
    emit(ProviderAvailabilitySaving(model));
    try {
      final uid = model.providerId.isNotEmpty
          ? model.providerId
          : (FirebaseAuth.instance.currentUser?.uid ?? '');
      final toSave = model.copyWith(providerId: uid);
      await _repo.saveAvailability(toSave);
      _currentModel = toSave;
      emit(ProviderAvailabilitySavedSuccess(toSave));
    } catch (e) {
      emit(ProviderAvailabilityError(e.toString()));
    }
  }

  void toggleDay(String day) {
    if (_currentModel == null) return;
    final currentDays = List<String>.from(_currentModel!.workingDays);
    if (currentDays.contains(day)) {
      currentDays.remove(day);
    } else {
      currentDays.add(day);
    }
    _currentModel = _currentModel!.copyWith(workingDays: currentDays);
    emit(ProviderAvailabilityLoaded(_currentModel!));
  }

  void addSlot(String slot) {
    if (_currentModel == null || slot.trim().isEmpty) return;
    final currentSlots = List<String>.from(_currentModel!.slots);
    if (!currentSlots.contains(slot.trim())) {
      currentSlots.add(slot.trim());
      currentSlots.sort();
      _currentModel = _currentModel!.copyWith(slots: currentSlots);
      emit(ProviderAvailabilityLoaded(_currentModel!));
    }
  }

  void removeSlot(String slot) {
    if (_currentModel == null) return;
    final currentSlots = List<String>.from(_currentModel!.slots);
    currentSlots.remove(slot);
    _currentModel = _currentModel!.copyWith(slots: currentSlots);
    emit(ProviderAvailabilityLoaded(_currentModel!));
  }

  void updateHours(String start, String end) {
    if (_currentModel == null) return;
    _currentModel = _currentModel!.copyWith(startHour: start, endHour: end);
    emit(ProviderAvailabilityLoaded(_currentModel!));
  }

  void toggleIsAvailable(bool isAvailable) {
    if (_currentModel == null) return;
    _currentModel = _currentModel!.copyWith(isAvailable: isAvailable);
    emit(ProviderAvailabilityLoaded(_currentModel!));
  }

  void reset() {
    _currentModel = null;
    emit(ProviderAvailabilityInitial());
  }
}
