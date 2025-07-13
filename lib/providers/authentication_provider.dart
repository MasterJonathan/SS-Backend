// lib/providers/authentication_provider.dart

import 'dart:async';
import 'package:admin_dashboard_template/core/auth/auth_service.dart';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthenticationProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  late StreamSubscription<User?> _authSubscription;
  
  AuthStatus _status = AuthStatus.Uninitialized;
  User? _firebaseUser;
  UserModel? _userModel;

  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _userModel;
  bool get isAuthenticated => _status == AuthStatus.Authenticated;

  AuthenticationProvider({
    required AuthService authService, 
    required FirestoreService firestoreService,
  }) : _authService = authService, _firestoreService = firestoreService {
    _initialize();
  }

  void _initialize() {
    _authSubscription = _authService.authStateChanges.listen(_onAuthStateChanged);
    _onAuthStateChanged(_authService.currentUser); // Periksa status awal
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      _status = AuthStatus.Unauthenticated;
      _firebaseUser = null;
      _userModel = null;
    } else {
      _firebaseUser = user;
      // Ambil data profil dari Firestore setelah login/register
      _userModel = await _firestoreService.getUser(user.uid);
      
      // Jika profil tidak ditemukan (misal user login dengan Google/provider lain pertama kali)
      // Anda bisa membuat profil default di sini.
      if (_userModel == null) {
        print("Profil Firestore untuk user ${user.uid} tidak ditemukan. Mungkin perlu dibuatkan.");
        // Untuk alur register, profil seharusnya sudah dibuat.
        // Ini lebih relevan untuk Social Login.
      }
      
      _status = AuthStatus.Authenticated;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(hasListeners) notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _setState(AuthStatus.Authenticating);
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      // _onAuthStateChanged akan dipicu secara otomatis oleh listener
      return true;
    } catch (e) {
      _setState(AuthStatus.Unauthenticated);
      print(e); 
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    _setState(AuthStatus.Authenticating);
    try {
      final credential = await _authService.createUserWithEmailAndPassword(email, password);
      if (credential?.user != null) {
        // --- INI BAGIAN PENTING UNTUK MEMBUAT PROFIL DI FIRESTORE ---
        UserModel newUser = UserModel(
          id: credential!.user!.uid, // Gunakan UID dari Auth sebagai ID dokumen
          email: email,
          nama: name,
          username: name,
          role: 'Admin', // Peran default untuk admin panel
          photoURL: 'https://static.vecteezy.com/system/resources/previews/020/765/399/original/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg',
          jumlahComment: 0,
          jumlahKontributor: 0,
          jumlahLike: 0,
          jumlahShare: 0,
          alamat: '',
          jenisKelamin: '',
          nomorHp: '',
          tanggalLahir: '',
          status: true,
          joinDate: DateTime.now(),
        );
        // Panggil service untuk menyimpan profil baru ini ke Firestore
        await _firestoreService.setUserProfile(newUser);
        // -------------------------------------------------------------

        // Setelah berhasil mendaftar dan membuat profil, langsung logout.
        await _authService.signOut();
        
        return true;
      }
      return false;
    } catch (e) {
      _setState(AuthStatus.Unauthenticated);
      print(e);
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _setState(AuthStatus.Unauthenticated);
  }

  void _setState(AuthStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}