// lib/models/infoss_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Helper function untuk parsing tanggal yang aman
DateTime _parseSafeTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  // Menangani format 'MM/dd/yyyy HH:mm' dari screenshot
  if (value is String) {
    try {
      // Coba format yang paling mungkin terlebih dahulu
      return DateFormat('MM/dd/yyyy HH:mm').parse(value);
    } catch (e) {
      // Jika gagal, coba format standar ISO 8601
      try {
        return DateTime.parse(value);
      } catch (e2) {
        // Jika semua gagal, kembalikan waktu sekarang sebagai fallback
        print('Error parsing date string: $value. Error: $e2');
        return DateTime.now();
      }
    }
  }
  // Fallback jika tipe data tidak dikenali
  return DateTime.now();
}

class InfossModel {
  final String id; // ID Dokumen dari Firestore
  final String? detail;
  final String? gambar;
  final String judul;
  final int jumlahComment;
  final int jumlahLike;
  final int jumlahShare;
  final int jumlahView;
  final String kategori;
  final double? latitude;
  final String? location;
  final double? longitude;
  // 'title' tampaknya duplikat dari 'judul', kita akan utamakan 'judul'
  final DateTime uploadDate;

  InfossModel({
    required this.id,
    this.detail,
    this.gambar,
    required this.judul,
    required this.jumlahComment,
    required this.jumlahLike,
    required this.jumlahShare,
    required this.jumlahView,
    required this.kategori,
    this.latitude,
    this.location,
    this.longitude,
    required this.uploadDate,
  });

  factory InfossModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    
    return InfossModel(
      id: snapshot.id, // Selalu gunakan ID dokumen sebagai sumber kebenaran
      detail: data?['detail'],
      gambar: data?['gambar'],
      // Gunakan 'judul' sebagai prioritas, jika tidak ada, baru 'title'
      judul: data?['judul'] ?? data?['title'] ?? '',
      jumlahComment: data?['jumlahComment'] ?? 0,
      jumlahLike: data?['jumlahLike'] ?? 0,
      jumlahShare: data?['jumlahShare'] ?? 0,
      jumlahView: data?['jumlahView'] ?? 0,
      kategori: data?['kategori'] ?? '',
      latitude: (data?['latitude'] as num?)?.toDouble(),
      location: data?['location'],
      longitude: (data?['longitude'] as num?)?.toDouble(),
      uploadDate: _parseSafeTimestamp(data?['uploadDate']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      // Tidak perlu menyimpan 'id' di dalam field, karena sudah menjadi ID dokumen
      if (detail != null) 'detail': detail,
      if (gambar != null) 'gambar': gambar,
      'judul': judul,
      'jumlahComment': jumlahComment,
      'jumlahLike': jumlahLike,
      'jumlahShare': jumlahShare,
      'jumlahView': jumlahView,
      'kategori': kategori,
      if (latitude != null) 'latitude': latitude,
      if (location != null) 'location': location,
      if (longitude != null) 'longitude': longitude,
      'uploadDate': Timestamp.fromDate(uploadDate),
    };
  }
}