import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/exceptions.dart';

class FirebaseAuthDatasource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDatasource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException('User data not found');
      }

      return {
        ...userDoc.data()!,
        'id': userCredential.user!.uid,
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getMessageFromErrorCode(e.code));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': userData['name'],
        'lastName': userData['lastName'],
        'birthDate': userData['birthDate'],
        'email': userData['email'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        ...userData,
        'id': userCredential.user!.uid,
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getMessageFromErrorCode(e.code));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Stream<Map<String, dynamic>?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) return null;

      return {
        ...userDoc.data()!,
        'id': firebaseUser.uid,
      };
    });
  }

  String _getMessageFromErrorCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No se encontró un usuario con este email.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'operation-not-allowed':
        return 'Operación no permitida.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      case 'invalid-credential':
        return 'Credenciales incorrectas';
      default:
        return 'Ha ocurrido un error.';
    }
  }
}