// lib/providers/chat_provider.dart

import 'dart:async';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/models/infoss_comment_model.dart'; // Gunakan model yang sesuai
import 'package:flutter/material.dart';

enum ChatViewState { Idle, Busy }

class ChatProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late StreamSubscription _infossCommentsSubscription;
  // Tambahkan subscription lain untuk kawanssComments, dll.

  List<InfossCommentModel> _infossComments = [];
  ChatViewState _state = ChatViewState.Busy;
  String? _errorMessage;

  List<InfossCommentModel> get infossComments => _infossComments;
  ChatViewState get state => _state;
  String? get errorMessage => _errorMessage;

  ChatProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _listenToInfossComments();
    // Panggil listener lain di sini
  }

  void _listenToInfossComments() {
    // Anda perlu menambahkan 'getInfossCommentsStream' di FirestoreService
    _infossCommentsSubscription = _firestoreService.getInfossCommentsStream().listen((data) {
      _infossComments = data;
      _setState(ChatViewState.Idle);
    }, onError: (error) {
      _errorMessage = "Gagal memuat komentar infoss: $error";
      _setState(ChatViewState.Idle);
    });
  }

  // Metode untuk menghapus atau mengedit komentar
  Future<bool> updateComment(InfossCommentModel comment) async {
    _setState(ChatViewState.Busy);
    try {
      // Anda perlu menambahkan 'updateInfossComment' di FirestoreService
      await _firestoreService.updateInfossComment(comment);
      _setState(ChatViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ChatViewState.Idle);
      return false;
    }
  }

  Future<bool> deleteComment(String commentId) async {
    _setState(ChatViewState.Busy);
    try {
      // Anda perlu menambahkan 'deleteInfossComment' di FirestoreService
      await _firestoreService.deleteInfossComment(commentId);
      _setState(ChatViewState.Idle);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ChatViewState.Idle);
      return false;
    }
  }

  void _setState(ChatViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _infossCommentsSubscription.cancel();
    // Pastikan untuk cancel subscription lain di sini
    super.dispose();
  }
}