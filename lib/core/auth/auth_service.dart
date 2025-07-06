

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  
  
  User? get currentUser => _auth.currentUser;

  
  
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException {
      
      rethrow;
    }
  }

  
  
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException {
      
      rethrow;
    }
  }

  
  Future<void> signOut() async {
    await _auth.signOut();
  }
}