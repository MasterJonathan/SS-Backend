// lib/providers/news_provider.dart

import 'dart:async';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/models/news_model.dart';
import 'package:flutter/material.dart';

enum NewsViewState { Idle, Busy }

class NewsProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late StreamSubscription _streamSubscription;

  List<NewsModel> _newsList = [];
  NewsViewState _state = NewsViewState.Busy;
  String? _errorMessage;

  List<NewsModel> get newsList => _newsList;
  NewsViewState get state => _state;
  String? get errorMessage => _errorMessage;

  NewsProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _listenToNews();
  }

  void _listenToNews() {
    // Anda perlu menambahkan 'getNewsStream' di FirestoreService
    _streamSubscription = _firestoreService.getNewsStream().listen((data) {
      _newsList = data;
      _setState(NewsViewState.Idle);
    }, onError: (error) {
      _errorMessage = "Gagal memuat data berita: $error";
      _setState(NewsViewState.Idle);
    });
  }

  Future<bool> addNews(NewsModel news) async {
    _setState(NewsViewState.Busy);
    try {
      // Anda perlu menambahkan 'addNews' di FirestoreService
      await _firestoreService.addNews(news);
      _setState(NewsViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(NewsViewState.Idle);
      return false;
    }
  }

  Future<bool> updateNews(NewsModel news) async {
    _setState(NewsViewState.Busy);
    try {
      // Anda perlu menambahkan 'updateNews' di FirestoreService
      await _firestoreService.updateNews(news);
      _setState(NewsViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(NewsViewState.Idle);
      return false;
    }
  }

  Future<bool> deleteNews(String newsId) async {
    _setState(NewsViewState.Busy);
    try {
      // Anda perlu menambahkan 'deleteNews' di FirestoreService
      await _firestoreService.deleteNews(newsId);
      _setState(NewsViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(NewsViewState.Idle);
      return false;
    }
  }

  void _setState(NewsViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}