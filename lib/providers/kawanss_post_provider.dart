// lib/providers/kawanss_post_provider.dart

import 'dart:async';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/models/kawanss_model.dart';
import 'package:flutter/material.dart';

enum KawanssPostViewState { Idle, Busy }

class KawanssPostProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late StreamSubscription _streamSubscription;

  List<KawanssModel> _posts = [];
  KawanssPostViewState _state = KawanssPostViewState.Busy;
  String? _errorMessage;

  List<KawanssModel> get posts => _posts;
  KawanssPostViewState get state => _state;
  String? get errorMessage => _errorMessage;

  KawanssPostProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _listenToPosts();
  }

  void _listenToPosts() {
    // Menggunakan metode getKawanssStream yang sudah ada di FirestoreService
    _streamSubscription = _firestoreService.getKawanssStream().listen((data) {
      _posts = data;
      _setState(KawanssPostViewState.Idle);
    }, onError: (error) {
      _errorMessage = "Gagal memuat data post: $error";
      _setState(KawanssPostViewState.Idle);
    });
  }

  // Metode untuk update dan delete bisa menggunakan metode yang sama dari FirestoreService
  Future<bool> updatePost(KawanssModel post) async {
    _setState(KawanssPostViewState.Busy);
    try {
      await _firestoreService.updateKawanss(post);
      _setState(KawanssPostViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(KawanssPostViewState.Idle);
      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    _setState(KawanssPostViewState.Busy);
    try {
      await _firestoreService.deleteKawanss(postId);
      _setState(KawanssPostViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(KawanssPostViewState.Idle);
      return false;
    }
  }

  void _setState(KawanssPostViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}