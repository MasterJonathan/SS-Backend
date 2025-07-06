// lib/models/kontributor_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class KontributorModel {
  final String id;
  final String? accountName;
  final bool deleted;
  final String? deskripsi;
  final String? gambar;
  final String? judul;
  final int jumlahComment;
  final int jumlahLaporan;
  final int jumlahLike;
  final String? kontributorPhotoURL;
  final String? lokasi;
  final DateTime uploadDate;
  final String? userId;
  final String? email;
  final String? telepon;

  KontributorModel({
    required this.id,
    this.accountName,
    required this.deleted,
    this.deskripsi,
    this.gambar,
    this.judul,
    required this.jumlahComment,
    required this.jumlahLaporan,
    required this.jumlahLike,
    this.kontributorPhotoURL,
    this.lokasi,
    required this.uploadDate,
    this.userId,
    this.email,
    this.telepon,
  });

  factory KontributorModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return KontributorModel(
      id: snapshot.id,
      accountName: data?['accountName'],
      deleted: data?['deleted'] ?? false,
      deskripsi: data?['deskripsi'],
      gambar: data?['gambar'],
      judul: data?['judul'],
      jumlahComment: data?['jumlahComment'] ?? 0,
      jumlahLaporan: data?['jumlahLaporan'] ?? 0,
      jumlahLike: data?['jumlahLike'] ?? 0,
      kontributorPhotoURL: data?['kontributorPhotoURL'],
      lokasi: data?['lokasi'],
      uploadDate: (data?['uploadDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data?['userId'],
      email: data?['email'],
      telepon: data?['telepon'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (accountName != null) 'accountName': accountName,
      'deleted': deleted,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (gambar != null) 'gambar': gambar,
      if (judul != null) 'judul': judul,
      'jumlahComment': jumlahComment,
      'jumlahLaporan': jumlahLaporan,
      'jumlahLike': jumlahLike,
      if (kontributorPhotoURL != null) 'kontributorPhotoURL': kontributorPhotoURL,
      if (lokasi != null) 'lokasi': lokasi,
      'uploadDate': Timestamp.fromDate(uploadDate),
      if (userId != null) 'userId': userId,
      if (email != null) 'email': email,
      if (telepon != null) 'telepon': telepon,
    };
  }
}