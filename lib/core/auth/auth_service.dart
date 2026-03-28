import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthRole { superAdmin, admin, agent }

class AuthUserProfile {
  const AuthUserProfile({
    required this.uid,
    required this.email,
    required this.role,
  });

  final String uid;
  final String? email;
  final AuthRole role;
}

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  Future<AuthUserProfile> getCurrentProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user found.');
    }

    final tokenResult = await user.getIdTokenResult(true);
    final claimRole = tokenResult.claims?['role']?.toString();
    final mappedClaimRole = _mapRole(claimRole);
    if (mappedClaimRole != null) {
      return AuthUserProfile(
        uid: user.uid,
        email: user.email,
        role: mappedClaimRole,
      );
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final firestoreRole = doc.data()?['role']?.toString();
    final mappedFirestoreRole = _mapRole(firestoreRole);
    if (mappedFirestoreRole == null) {
      throw StateError(
        'User role is missing. Configure role in custom claims or users collection.',
      );
    }

    return AuthUserProfile(
      uid: user.uid,
      email: user.email,
      role: mappedFirestoreRole,
    );
  }

  AuthRole? _mapRole(String? role) {
    switch (role) {
      case 'super_admin':
        return AuthRole.superAdmin;
      case 'admin':
        return AuthRole.admin;
      case 'agent':
        return AuthRole.agent;
      default:
        return null;
    }
  }
}
