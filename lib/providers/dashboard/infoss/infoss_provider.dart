// lib/providers/infoss_provider.dart

import 'dart:async';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/models/dashboard/infoss/infoss_model.dart';
import 'package:flutter/material.dart';

enum InfossViewState { Idle, Busy }

class InfossProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late StreamSubscription _streamSubscription;

  List<InfossModel> _infossList = [];
  InfossViewState _state = InfossViewState.Busy;
  String? _errorMessage;

  List<InfossModel> get infossList => _infossList;
  InfossViewState get state => _state;
  String? get errorMessage => _errorMessage;

  InfossProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _listenToInfoss();
  }

  void _listenToInfoss() {
    // Anda perlu menambahkan 'getInfossStream' di FirestoreService
    _streamSubscription = _firestoreService.getInfossStream().listen((data) {
      _infossList = data;
      _setState(InfossViewState.Idle);
    }, onError: (error) {
      _errorMessage = "Gagal memuat data Infoss: $error";
      _setState(InfossViewState.Idle);
    });
  }

  Future<bool> addInfoss(InfossModel infoss) async {
    _setState(InfossViewState.Busy);
    try {
      // Anda perlu menambahkan 'addInfoss' di FirestoreService
      await _firestoreService.addInfoss(infoss);
      _setState(InfossViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(InfossViewState.Idle);
      return false;
    }
  }

  Future<bool> updateInfoss(InfossModel infoss) async {
    _setState(InfossViewState.Busy);
    try {
      // Anda perlu menambahkan 'updateInfoss' di FirestoreService
      await _firestoreService.updateInfoss(infoss);
      _setState(InfossViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(InfossViewState.Idle);
      return false;
    }
  }

  Future<bool> deleteInfoss(String infossId) async {
    _setState(InfossViewState.Busy);
    try {
      // Anda perlu menambahkan 'deleteInfoss' di FirestoreService
      await _firestoreService.deleteInfoss(infossId);
      _setState(InfossViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(InfossViewState.Idle);
      return false;
    }
  }

  void _setState(InfossViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}