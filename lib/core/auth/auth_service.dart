// lib/core/auth/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream untuk memantau perubahan status otentikasi (login/logout).
  /// Sangat berguna untuk mengarahkan pengguna secara otomatis.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Mendapatkan instance pengguna yang sedang login.
  /// Bisa null jika tidak ada yang login.
  User? get currentUser => _auth.currentUser;

  /// Fungsi untuk login dengan email dan password.
  /// Melemparkan [FirebaseAuthException] jika terjadi error.
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Menggunakan metode dari FirebaseAuth untuk login
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException {
      // Biarkan error dilempar ke atas (ke AuthProvider) untuk ditangani.
      rethrow;
    }
  }

  /// Fungsi untuk mendaftar pengguna baru dengan email dan password.
  /// Melemparkan [FirebaseAuthException] jika terjadi error.
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      // Menggunakan metode dari FirebaseAuth untuk membuat user baru
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException {
      // Biarkan error dilempar ke atas (ke AuthProvider) untuk ditangani.
      rethrow;
    }
  }

  /// Fungsi untuk logout.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}