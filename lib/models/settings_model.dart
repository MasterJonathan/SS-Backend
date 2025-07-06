// lib/models/settings_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsModel {
  final String audioStreamingUrl;
  final String visualRadioUrl;
  final String termsAndConditions;
  final bool isChatActive;

  SettingsModel({
    required this.audioStreamingUrl,
    required this.visualRadioUrl,
    required this.termsAndConditions,
    required this.isChatActive,
  });

  // Factory constructor untuk membuat instance dari data Firestore
  factory SettingsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return SettingsModel(
      audioStreamingUrl: data?['audioStreamingUrl'] ?? '',
      visualRadioUrl: data?['visualRadioUrl'] ?? '',
      termsAndConditions: data?['termsAndConditions'] ?? '',
      isChatActive: data?['isChatActive'] ?? false,
    );
  }

  // Method untuk mengubah instance menjadi Map agar bisa disimpan ke Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'audioStreamingUrl': audioStreamingUrl,
      'visualRadioUrl': visualRadioUrl,
      'termsAndConditions': termsAndConditions,
      'isChatActive': isChatActive,
    };
  }
}