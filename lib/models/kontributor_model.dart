import 'package:cloud_firestore/cloud_firestore.dart';

class KontributorModel {
  final String id; // Document ID
  final String? accountName;
  final bool deleted;
  final String? deskripsi;
  final String? gambar;
  final String? judul;
  final int jumlahComment;
  final int jumlahLaporan;
  final int jumlahLike;
  final String? kontributorPhotoURL; // Field name is 'kontributorPhotoURL'
  final String? lokasi;
  final DateTime uploadDate;
  // Add userId if it exists for kontributor posts

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
    };
  }
}