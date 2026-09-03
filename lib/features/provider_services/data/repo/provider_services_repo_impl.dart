import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProviderServicesRepoImpl implements ProviderServicesRepo {
  final FirebaseFirestore _firestore;

  ProviderServicesRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ServiceModel>> getProviderServices(String providerId) async {
    final uid = providerId.isNotEmpty
        ? providerId
        : (FirebaseAuth.instance.currentUser?.uid ?? "");
    if (uid.isEmpty) return [];

    try {
      // 1. Check provider's dedicated isolated subcollection: users/{uid}/services
      final userServicesSnap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('services')
          .get();

      if (userServicesSnap.docs.isNotEmpty) {
        final list = userServicesSnap.docs
            .map((doc) => ServiceModel.fromJson(doc.data(), doc.id))
            .toList();
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      }

      // 2. Fallback: check root collection strictly for this providerId
      final rootSnap = await _firestore
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .get();

      final list = <ServiceModel>[];
      for (final doc in rootSnap.docs) {
        final service = ServiceModel.fromJson(doc.data(), doc.id);
        list.add(service);
        // Sync to provider subcollection so it's isolated permanently
        try {
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('services')
              .doc(doc.id)
              .set(service.toJson(), SetOptions(merge: true));
        } catch (_) {}
      }

      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (_) {
      return [];
    }
  }

  @override
  Stream<List<ServiceModel>> getProviderServicesStream(String providerId) {
    final uid = providerId.isNotEmpty
        ? providerId
        : (FirebaseAuth.instance.currentUser?.uid ?? "");
    if (uid.isEmpty) return Stream.value([]);

    // Listen to the provider's dedicated isolated subcollection: users/{uid}/services
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('services')
        .snapshots()
        .asyncMap((userServicesSnap) async {
      if (userServicesSnap.docs.isNotEmpty) {
        final list = userServicesSnap.docs
            .map((doc) => ServiceModel.fromJson(doc.data(), doc.id))
            .toList();
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      }

      // If subcollection is empty, check root collection strictly for this providerId
      final rootSnap = await _firestore
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .get();

      final list = <ServiceModel>[];
      for (final doc in rootSnap.docs) {
        final s = ServiceModel.fromJson(doc.data(), doc.id);
        list.add(s);
        try {
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('services')
              .doc(doc.id)
              .set(s.toJson(), SetOptions(merge: true));
        } catch (_) {}
      }
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    }).handleError((_) => <ServiceModel>[]);
  }

  @override
  Future<List<ServiceModel>> getAllActiveServices() async {
    final querySnapshot = await _firestore
        .collection('services')
        .where('isActive', isEqualTo: true)
        .get();

    final list = querySnapshot.docs
        .map((doc) => ServiceModel.fromJson(doc.data(), doc.id))
        .toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Stream<List<ServiceModel>> getAllActiveServicesStream() {
    return _firestore
        .collection('services')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data(), doc.id))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  @override
  Future<void> addService(ServiceModel service) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = service.providerId.isNotEmpty
        ? service.providerId
        : (user?.uid ?? '');

    String? providerName = service.providerName ?? user?.displayName;
    String? providerImage = service.providerImage ?? user?.photoURL;

    if (uid.isNotEmpty) {
      try {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          final docData = doc.data();
          if (docData != null) {
            final nameInDoc = docData['name'] as String?;
            if (nameInDoc != null && nameInDoc.trim().isNotEmpty) {
              providerName = nameInDoc.trim();
            }
            final photoInDoc = docData['photoUrl'] as String?;
            if (photoInDoc != null && photoInDoc.isNotEmpty) {
              providerImage = photoInDoc;
            }
          }
        }
      } catch (_) {}
    }

    final docRef = _firestore.collection('services').doc();
    final serviceId = (service.id != null && service.id!.isNotEmpty)
        ? service.id!
        : docRef.id;

    final finalService = service.copyWith(
      id: serviceId,
      providerId: uid,
      providerName: providerName,
      providerImage: providerImage,
      updatedAt: DateTime.now(),
    );

    // Save to global services collection for client discovery
    await _firestore
        .collection('services')
        .doc(serviceId)
        .set(finalService.toJson(), SetOptions(merge: true));

    // Also save to provider's isolated subcollection: users/{uid}/services/{serviceId}
    if (uid.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('services')
          .doc(serviceId)
          .set(finalService.toJson(), SetOptions(merge: true));
    }
  }

  @override
  Future<void> updateService(ServiceModel service) async {
    if (service.id == null || service.id!.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    final uid = service.providerId.isNotEmpty
        ? service.providerId
        : (user?.uid ?? '');

    final updated = service.copyWith(updatedAt: DateTime.now());

    // Update global collection
    await _firestore
        .collection('services')
        .doc(service.id)
        .set(updated.toJson(), SetOptions(merge: true));

    // Update provider isolated subcollection
    if (uid.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('services')
          .doc(service.id)
          .set(updated.toJson(), SetOptions(merge: true));
    }
  }

  @override
  Future<void> deleteService(String serviceId) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';

    // Delete from global collection
    await _firestore.collection('services').doc(serviceId).delete();

    // Delete from provider isolated subcollection
    if (uid.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('services')
          .doc(serviceId)
          .delete();
    }
  }

  @override
  Future<void> toggleServiceActive(String serviceId, bool isActive) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';

    final updateData = {
      'isActive': isActive,
      'updatedAt': Timestamp.now(),
    };

    // Update in global collection
    await _firestore.collection('services').doc(serviceId).update(updateData);

    // Update in provider subcollection
    if (uid.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('services')
          .doc(serviceId)
          .update(updateData);
    }
  }
}
