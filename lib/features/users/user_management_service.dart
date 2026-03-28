import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class UserManagementService {
  UserManagementService({
    FirebaseFunctions? functions,
    FirebaseFirestore? firestore,
  }) : _functions = functions ?? FirebaseFunctions.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFunctions _functions;
  final FirebaseFirestore _firestore;

  Stream<List<Map<String, dynamic>>> watchManageableUsers() {
    return _firestore
        .collection('users')
        .where('role', whereIn: ['admin', 'agent'])
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'uid': doc.id, ...doc.data()})
              .toList(),
        );
  }

  Future<String> createAdminOrAgent({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) async {
    final callable = _functions.httpsCallable('createUserWithRole');
    final response = await callable.call({
      'email': email,
      'password': password,
      'displayName': displayName,
      'role': role,
    });

    return response.data['uid'] as String;
  }

  Future<void> updateUserRole({
    required String uid,
    required String role,
  }) async {
    await _functions.httpsCallable('updateUserRole').call({
      'uid': uid,
      'role': role,
    });
  }

  Future<void> setUserDisabled({
    required String uid,
    required bool disabled,
  }) async {
    await _functions.httpsCallable('setUserDisabled').call({
      'uid': uid,
      'disabled': disabled,
    });
  }

  Future<void> deleteUser({required String uid}) async {
    await _functions.httpsCallable('deleteUser').call({'uid': uid});
  }
}
