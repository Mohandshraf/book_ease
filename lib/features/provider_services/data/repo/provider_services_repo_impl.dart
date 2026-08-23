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
      final querySnapshot = await _firestore
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .get();

      final list = querySnapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data(), doc.id))
          .toList();

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

    return _firestore
        .collection('services')
        .where('providerId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data(), doc.id))
          .toList();
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

    final finalService = service.copyWith(
      providerId: uid,
      providerName: providerName,
      providerImage: providerImage,
      updatedAt: DateTime.now(),
    );

    await _firestore.collection('services').add(finalService.toJson());
  }

  @override
  Future<void> updateService(ServiceModel service) async {
    if (service.id == null || service.id!.isEmpty) return;
    final updated = service.copyWith(updatedAt: DateTime.now());
    await _firestore
        .collection('services')
        .doc(service.id)
        .update(updated.toJson());
  }

  @override
  Future<void> deleteService(String serviceId) async {
    await _firestore.collection('services').doc(serviceId).delete();
  }

  @override
  Future<void> toggleServiceActive(String serviceId, bool isActive) async {
    await _firestore.collection('services').doc(serviceId).update({
      'isActive': isActive,
      'updatedAt': Timestamp.now(),
    });
  }
}
