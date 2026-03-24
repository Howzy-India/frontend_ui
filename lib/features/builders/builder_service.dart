import 'dart:typed_data';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BuilderService {
  BuilderService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseFunctions? functions,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance,
       _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseFunctions _functions;

  Stream<List<Map<String, dynamic>>> watchBuilders({String? status}) {
    var query = _firestore
        .collection('builders')
        .orderBy('updatedAt', descending: true);
    if (status != null) {
      query = query.where('onboardingStatus', isEqualTo: status);
    }

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(),
    );
  }

  Stream<List<Map<String, dynamic>>> watchPendingApprovals() {
    return _firestore
        .collection('approvals')
        .where('status', isEqualTo: 'pending')
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(),
        );
  }

  Stream<List<Map<String, dynamic>>> watchApprovedBuilderProjects() {
    return _firestore
        .collection('builders')
        .where('onboardingStatus', isEqualTo: 'approved')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(),
        );
  }

  Future<String> createBuilderDraft(Map<String, dynamic> data) async {
    final payload = {
      ...data,
      'onboardingStatus': 'draft',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final ref = await _firestore.collection('builders').add(payload);
    return ref.id;
  }

  Future<void> updateBuilder(
    String builderId,
    Map<String, dynamic> updates,
  ) async {
    await _firestore.collection('builders').doc(builderId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteBuilderIfUnapproved(String builderId) async {
    await _functions.httpsCallable('deleteBuilderIfUnapproved').call({
      'builderId': builderId,
    });
  }

  Future<String> uploadAgreement({
    required String builderId,
    required File file,
    required String uploadedBy,
  }) async {
    final fileName = file.uri.pathSegments.last;
    final path = 'builder_agreements/$builderId/$fileName';
    final ref = _storage.ref(path);
    await ref.putFile(file);
    final downloadUrl = await ref.getDownloadURL();

    await _firestore
        .collection('builders')
        .doc(builderId)
        .collection('agreements')
        .add({
          'storagePath': path,
          'downloadUrl': downloadUrl,
          'fileName': fileName,
          'uploadedBy': uploadedBy,
          'uploadedAt': FieldValue.serverTimestamp(),
        });

    return downloadUrl;
  }

  Future<String> uploadAgreementBytes({
    required String builderId,
    required Uint8List bytes,
    required String fileName,
    required String uploadedBy,
    String? contentType,
  }) async {
    final path = 'builder_agreements/$builderId/$fileName';
    final ref = _storage.ref(path);
    await ref.putData(
      bytes,
      SettableMetadata(contentType: contentType ?? 'application/octet-stream'),
    );
    final downloadUrl = await ref.getDownloadURL();

    await _firestore
        .collection('builders')
        .doc(builderId)
        .collection('agreements')
        .add({
          'storagePath': path,
          'downloadUrl': downloadUrl,
          'fileName': fileName,
          'uploadedBy': uploadedBy,
          'uploadedAt': FieldValue.serverTimestamp(),
        });

    return downloadUrl;
  }

  Future<void> submitForApproval(String builderId) async {
    await _functions.httpsCallable('submitBuilderForApproval').call({
      'builderId': builderId,
    });
  }

  Future<void> approveBuilder({
    required String approvalId,
    String? remarks,
  }) async {
    await _functions.httpsCallable('approveBuilder').call({
      'approvalId': approvalId,
      'remarks': remarks,
    });
  }

  Future<void> rejectBuilder({
    required String approvalId,
    required String remarks,
  }) async {
    await _functions.httpsCallable('rejectBuilder').call({
      'approvalId': approvalId,
      'remarks': remarks,
    });
  }
}
