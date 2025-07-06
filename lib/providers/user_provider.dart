// lib/providers/user_provider.dart

import 'dart:async';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/models/user_model.dart';
import 'package:flutter/material.dart';

enum UserViewState { Idle, Busy }

class UserProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late StreamSubscription _streamSubscription;

  List<UserModel> _users = [];
  UserViewState _state = UserViewState.Busy; // Mulai dengan status Busy
  String? _errorMessage;

  List<UserModel> get users => _users;
  UserViewState get state => _state;
  String? get errorMessage => _errorMessage;

  UserProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _listenToUsers();
  }

  void _listenToUsers() {
    _streamSubscription = _firestoreService.getUsersStream().listen((userData) {
      _users = userData;
      _setState(UserViewState.Idle);
    }, onError: (error) {
      _errorMessage = "Gagal memuat data pengguna: $error";
      _setState(UserViewState.Idle);
    });
  }

  Future<bool> addUser(UserModel user) async {
    _setState(UserViewState.Busy);
    try {
      await _firestoreService.addUser(user);
      _setState(UserViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UserViewState.Idle);
      return false;
    }
  }

  Future<bool> updateUser(UserModel user) async {
    _setState(UserViewState.Busy);
    try {
      await _firestoreService.updateUser(user);
      _setState(UserViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UserViewState.Idle);
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    _setState(UserViewState.Busy);
    try {
      await _firestoreService.deleteUser(userId);
      _setState(UserViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UserViewState.Idle);
      return false;
    }
  }

   Future<bool> updateUserPartial(String userId, Map<String, dynamic> data) async {
    // Kita bisa set state ke Busy jika ingin ada loading,
    // tapi untuk toggle biasanya tidak perlu.
    try {
      await _firestoreService.updateUserPartial(userId, data);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _setState(UserViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}