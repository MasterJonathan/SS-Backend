import 'package:cloud_firestore/cloud_firestore.dart';

class InfossModel {
  final String id; // Document ID
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
  final String title; // Seems duplicative of judul, confirm usage
  final DateTime uploadDate;
  // Add other fields if present (e.g., userId who posted)

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
    required this.title,
    required this.uploadDate,
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
      uploadDate: (data?['uploadDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
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
      'title': title,
      'uploadDate': Timestamp.fromDate(uploadDate),
    };
  }
}