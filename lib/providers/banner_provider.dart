// lib/providers/banner_provider.dart

import 'dart:async';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/models/banner_model.dart';
import 'package:flutter/material.dart';

enum BannerViewState { Idle, Busy }

class BannerProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late StreamSubscription _streamSubscription;

  List<BannerTopModel> _banners = [];
  BannerViewState _state = BannerViewState.Busy;
  String? _errorMessage;

  List<BannerTopModel> get banners => _banners;
  BannerViewState get state => _state;
  String? get errorMessage => _errorMessage;

  BannerProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _listenToBanners();
  }

  void _listenToBanners() {
    // Anda perlu menambahkan 'getBannersStream' di FirestoreService
    _streamSubscription = _firestoreService.getBannersStream().listen((data) {
      _banners = data;
      _setState(BannerViewState.Idle);
    }, onError: (error) {
      _errorMessage = "Gagal memuat data banner: $error";
      _setState(BannerViewState.Idle);
    });
  }

  Future<bool> addBanner(BannerTopModel banner) async {
    _setState(BannerViewState.Busy);
    try {
      // Anda perlu menambahkan 'addBanner' di FirestoreService
      await _firestoreService.addBanner(banner);
      _setState(BannerViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(BannerViewState.Idle);
      return false;
    }
  }

  Future<bool> updateBanner(BannerTopModel banner) async {
    _setState(BannerViewState.Busy);
    try {
      // Anda perlu menambahkan 'updateBanner' di FirestoreService
      await _firestoreService.updateBanner(banner);
      _setState(BannerViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(BannerViewState.Idle);
      return false;
    }
  }

  Future<bool> deleteBanner(String bannerId) async {
    _setState(BannerViewState.Busy);
    try {
      // Anda perlu menambahkan 'deleteBanner' di FirestoreService
      await _firestoreService.deleteBanner(bannerId);
      _setState(BannerViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(BannerViewState.Idle);
      return false;
    }
  }

  void _setState(BannerViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}