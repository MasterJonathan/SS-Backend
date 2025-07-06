

import 'dart:async';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/models/kontributor_model.dart';
import 'package:flutter/material.dart';

enum KontributorViewState { Idle, Busy }

class KontributorProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late StreamSubscription _streamSubscription;

  List<KontributorModel> _kontributors = [];
  KontributorViewState _state = KontributorViewState.Busy;
  String? _errorMessage;

  List<KontributorModel> get kontributors => _kontributors;
  KontributorViewState get state => _state;
  String? get errorMessage => _errorMessage;

  KontributorProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _listenToKontributors();
  }

  void _listenToKontributors() {
    _streamSubscription = _firestoreService.getKontributorsStream().listen((data) {
      _kontributors = data;
      _setState(KontributorViewState.Idle);
    }, onError: (error) {
      _errorMessage = "Gagal memuat data kontributor: $error";
      _setState(KontributorViewState.Idle);
    });
  }

  Future<bool> addKontributor(KontributorModel kontributor) async {
    _setState(KontributorViewState.Busy);
    try {
      await _firestoreService.addKontributor(kontributor);
      _setState(KontributorViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(KontributorViewState.Idle);
      return false;
    }
  }

  Future<bool> updateKontributor(KontributorModel kontributor) async {
    _setState(KontributorViewState.Busy);
    try {
      await _firestoreService.updateKontributor(kontributor);
      _setState(KontributorViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(KontributorViewState.Idle);
      return false;
    }
  }

  Future<bool> deleteKontributor(String kontributorId) async {
    _setState(KontributorViewState.Busy);
    try {
      await _firestoreService.deleteKontributor(kontributorId);
      _setState(KontributorViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(KontributorViewState.Idle);
      return false;
    }
  }

  void _setState(KontributorViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}