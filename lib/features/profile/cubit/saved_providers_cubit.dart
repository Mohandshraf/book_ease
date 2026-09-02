import 'package:book_ease/features/profile/cubit/saved_providers_state.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedProvidersCubit extends Cubit<SavedProvidersState> {
  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;

  SavedProvidersCubit({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore,
        _auth = auth,
        super(const SavedProvidersInitial());

  String? get _currentUid {
    try {
      final auth = _auth ?? FirebaseAuth.instance;
      return auth.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }

  FirebaseFirestore? get _effectiveFirestore {
    try {
      return _firestore ?? FirebaseFirestore.instance;
    } catch (_) {
      return _firestore;
    }
  }

  bool isSaved(String? id) {
    if (id == null || id.isEmpty) return false;
    return state.savedIds.contains(id);
  }

  Future<void> loadSavedProviders() async {
    emit(SavedProvidersLoading(
      savedDoctors: state.savedDoctors,
      savedIds: state.savedIds,
    ));

    final uid = _currentUid;
    if (uid == null || uid.isEmpty) {
      // If unauthenticated or guest, keep current in-memory items
      emit(SavedProvidersLoaded(
        savedDoctors: state.savedDoctors,
        savedIds: state.savedIds,
      ));
      return;
    }

    try {
      final firestore = _effectiveFirestore;
      if (firestore == null) {
        emit(SavedProvidersLoaded(
          savedDoctors: state.savedDoctors,
          savedIds: state.savedIds,
        ));
        return;
      }

      QuerySnapshot<Map<String, dynamic>>? snapshot;
      try {
        snapshot = await firestore
            .collection('users')
            .doc(uid)
            .collection('saved_providers')
            .get(const GetOptions(source: Source.cache));
      } catch (_) {}

      if (snapshot == null || snapshot.docs.isEmpty) {
        try {
          snapshot = await firestore
              .collection('users')
              .doc(uid)
              .collection('saved_providers')
              .get()
              .timeout(const Duration(milliseconds: 1500), onTimeout: () {
            return firestore
                .collection('users')
                .doc(uid)
                .collection('saved_providers')
                .get(const GetOptions(source: Source.cache));
          });
        } catch (_) {}
      }

      if (snapshot == null) {
        emit(SavedProvidersLoaded(
          savedDoctors: state.savedDoctors,
          savedIds: state.savedIds,
        ));
        return;
      }

      final List<ServiceDetailsModel> loaded = [];
      final Set<String> ids = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final model = ServiceDetailsModel.fromMap(data);
        loaded.add(model);
        final docId = model.serviceId ?? model.providerId ?? doc.id;
        ids.add(docId);
      }

      emit(SavedProvidersLoaded(
        savedDoctors: List.unmodifiable(loaded),
        savedIds: Set.unmodifiable(ids),
      ));
    } catch (e) {
      // Even if remote load fails, keep local state
      emit(SavedProvidersLoaded(
        savedDoctors: state.savedDoctors,
        savedIds: state.savedIds,
      ));
    }
  }

  Future<void> toggleSaveDoctor(ServiceDetailsModel doctor) async {
    final docId = doctor.serviceId ?? doctor.providerId ?? doctor.providerName;
    final isAlreadySaved = state.savedIds.contains(docId);

    final updatedDoctors = List<ServiceDetailsModel>.from(state.savedDoctors);
    final updatedIds = Set<String>.from(state.savedIds);

    if (isAlreadySaved) {
      updatedIds.remove(docId);
      updatedDoctors.removeWhere(
        (d) => (d.serviceId ?? d.providerId ?? d.providerName) == docId,
      );
    } else {
      updatedIds.add(docId);
      // Add to front so newly saved appears first
      updatedDoctors.insert(0, doctor);
    }

    emit(SavedProvidersLoaded(
      savedDoctors: List.unmodifiable(updatedDoctors),
      savedIds: Set.unmodifiable(updatedIds),
    ));

    final uid = _currentUid;
    if (uid != null && uid.isNotEmpty) {
      try {
        final firestore = _effectiveFirestore;
        if (firestore != null) {
          final docRef = firestore
              .collection('users')
              .doc(uid)
              .collection('saved_providers')
              .doc(docId);

          if (isAlreadySaved) {
            await docRef.delete();
          } else {
            await docRef.set(doctor.toMap(), SetOptions(merge: true));
          }
        }
      } catch (_) {
        // Silent catch for remote sync error, state remains active
      }
    }
  }

  Future<void> removeSavedDoctor(String docId) async {
    if (!state.savedIds.contains(docId)) return;

    final updatedDoctors = List<ServiceDetailsModel>.from(state.savedDoctors);
    final updatedIds = Set<String>.from(state.savedIds);

    updatedIds.remove(docId);
    updatedDoctors.removeWhere(
      (d) => (d.serviceId ?? d.providerId ?? d.providerName) == docId,
    );

    emit(SavedProvidersLoaded(
      savedDoctors: List.unmodifiable(updatedDoctors),
      savedIds: Set.unmodifiable(updatedIds),
    ));

    final uid = _currentUid;
    if (uid != null && uid.isNotEmpty) {
      try {
        final firestore = _effectiveFirestore;
        if (firestore != null) {
          await firestore
              .collection('users')
              .doc(uid)
              .collection('saved_providers')
              .doc(docId)
              .delete();
        }
      } catch (_) {}
    }
  }
}
