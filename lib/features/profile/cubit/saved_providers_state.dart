import 'package:book_ease/features/service_details/data/service_details_model.dart';

abstract class SavedProvidersState {
  final List<ServiceDetailsModel> savedDoctors;
  final Set<String> savedIds;

  const SavedProvidersState({
    this.savedDoctors = const [],
    this.savedIds = const {},
  });
}

class SavedProvidersInitial extends SavedProvidersState {
  const SavedProvidersInitial() : super();
}

class SavedProvidersLoading extends SavedProvidersState {
  const SavedProvidersLoading({
    super.savedDoctors,
    super.savedIds,
  });
}

class SavedProvidersLoaded extends SavedProvidersState {
  const SavedProvidersLoaded({
    required super.savedDoctors,
    required super.savedIds,
  });
}

class SavedProvidersError extends SavedProvidersState {
  final String message;

  const SavedProvidersError({
    required this.message,
    super.savedDoctors,
    super.savedIds,
  });
}
