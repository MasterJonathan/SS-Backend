// lib/providers/settings_provider.dart

import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/models/settings_model.dart'; // Anda perlu membuat model ini
import 'package:flutter/material.dart';

enum SettingsViewState { Idle, Busy }

class SettingsProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  SettingsModel? _settings;
  SettingsViewState _state = SettingsViewState.Busy;
  String? _errorMessage;

  SettingsModel? get settings => _settings;
  SettingsViewState get state => _state;
  String? get errorMessage => _errorMessage;

  SettingsProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    _setState(SettingsViewState.Busy);
    try {
      // Anda perlu menambahkan 'getSettings' di FirestoreService
      _settings = await _firestoreService.getSettings();
      _setState(SettingsViewState.Idle);
    } catch (e) {
      _errorMessage = "Gagal memuat pengaturan: $e";
      _setState(SettingsViewState.Idle);
    }
  }

  Future<bool> updateSettings(SettingsModel newSettings) async {
    _setState(SettingsViewState.Busy);
    try {
      // Anda perlu menambahkan 'updateSettings' di FirestoreService
      await _firestoreService.updateSettings(newSettings);
      // Setelah berhasil update, fetch lagi data terbaru
      await fetchSettings();
      _setState(SettingsViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SettingsViewState.Idle);
      return false;
    }
  }

  void _setState(SettingsViewState newState) {
    _state = newState;
    notifyListeners();
  }
}