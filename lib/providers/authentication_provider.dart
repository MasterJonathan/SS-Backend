

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
    final initialUser = _authService.currentUser;
    if (initialUser != null) {
      _status = AuthStatus.Authenticating;
      _onAuthStateChanged(initialUser);
    } else {
      _status = AuthStatus.Unauthenticated;
    }
    _authSubscription = _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      _status = AuthStatus.Unauthenticated;
      _firebaseUser = null;
      _userModel = null;
    } else {
      if (_firebaseUser?.uid != user.uid) {
        _firebaseUser = user;
        _userModel = await _firestoreService.getUser(user.uid);
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
        UserModel newUser = UserModel(
          id: credential!.user!.uid,
          email: email,
          nama: name,
          role: 'Admin',
          jumlahComment: 0,
          jumlahKontributor: 0,
          jumlahLike: 0,
          jumlahShare: 0,
          aktivitas: 0,
          namaAktivitas: 'User Registration',
          waktu: DateTime.now(),
          alamat: '',
          jenisKelamin: '',
          nomorHp: '',
          photoURL: '',
          tanggalLahir: '',
          isActive: true,
        );
        await _firestoreService.addUser(newUser);
        
        
        
        
        
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
    _authSubscription?.cancel();
    super.dispose();
  }
}