import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

DateTime? _parseSafeTimestamp(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) {
    try {
      if (value.contains('/')) return DateFormat('MM/dd/yyyy HH:mm').parse(value);
      return DateTime.parse(value);
    } catch (e) { return null; }
  }
  return null;
}

class InfossModel {
  final String id; 
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
  final String title; 
  final DateTime uploadDate;

  InfossModel({
    required this.id, this.detail, this.gambar, required this.judul,
    required this.jumlahComment, required this.jumlahLike, required this.jumlahShare,
    required this.jumlahView, required this.kategori, this.latitude,
    this.location, this.longitude, required this.title, required this.uploadDate,
  });

  factory InfossModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return InfossModel(
      id: snapshot.id,
      detail: data?['detail'],
      gambar: data?['gambar'],
      judul: data?['judul'] ?? '',
      jumlahComment: data?['jumlahComment'] ?? 0,
      jumlahLike: data?['jumlahLike'] ?? 0,
      jumlahShare: data?['jumlahShare'] ?? 0,
      jumlahView: data?['jumlahView'] ?? 0,
      kategori: data?['kategori'] ?? '',
      latitude: (data?['latitude'] as num?)?.toDouble(),
      location: data?['location'],
      longitude: (data?['longitude'] as num?)?.toDouble(),
      title: data?['title'] ?? '',
      uploadDate: _parseSafeTimestamp(data?['uploadDate']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (detail != null) 'detail': detail,
      if (gambar != null) 'gambar': gambar,
      'judul': judul, 'jumlahComment': jumlahComment, 'jumlahLike': jumlahLike,
      'jumlahShare': jumlahShare, 'jumlahView': jumlahView, 'kategori': kategori,
      if (latitude != null) 'latitude': latitude,
      if (location != null) 'location': location,
      if (longitude != null) 'longitude': longitude,
      'title': title, 'uploadDate': Timestamp.fromDate(uploadDate),
    };
  }
}