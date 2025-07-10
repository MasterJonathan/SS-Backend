// lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // Document ID (sinkron dengan UID dari Auth)
  final String email;
  final String nama;
  final String role;
  final String? photoURL;
  final DateTime? waktu; // Tanggal registrasi/aktivitas terakhir
  final String? alamat;
  final String? jenisKelamin;
  final int jumlahComment;
  final int jumlahKontributor;
  final int jumlahLike;
  final int jumlahShare;
  final String? nomorHp;
  final String? tanggalLahir;
  // 'aktivitas' dan 'namaAktivitas' bisa ditambahkan jika diperlukan di UI admin
  
  UserModel({
    required this.id,
    required this.email,
    required this.nama,
    required this.role,
    this.photoURL,
    this.waktu,
    this.alamat,
    this.jenisKelamin,
    required this.jumlahComment,
    required this.jumlahKontributor,
    required this.jumlahLike,
    required this.jumlahShare,
    this.nomorHp,
    this.tanggalLahir,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return UserModel(
      id: snapshot.id,
      email: data?['email'] ?? '',
      nama: data?['nama'] ?? 'No Name',
      role: data?['role'] ?? 'User',
      photoURL: data?['photoURL'],
      waktu: (data?['waktu'] as Timestamp?)?.toDate(),
      alamat: data?['alamat'],
      jenisKelamin: data?['jenis_kelamin'],
      jumlahComment: data?['jumlahComment'] ?? 0,
      jumlahKontributor: data?['jumlahKontributor'] ?? 0,
      jumlahLike: data?['jumlahLike'] ?? 0,
      jumlahShare: data?['jumlahShare'] ?? 0,
      nomorHp: data?['nomor_hp'],
      tanggalLahir: data?['tanggal_lahir'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'nama': nama,
      'role': role,
      'id': id, // Simpan juga ID di dalam dokumen untuk kemudahan query
      if (photoURL != null) 'photoURL': photoURL,
      if (waktu != null) 'waktu': Timestamp.fromDate(waktu!),
      if (alamat != null) 'alamat': alamat,
      if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
      'jumlahComment': jumlahComment,
      'jumlahKontributor': jumlahKontributor,
      'jumlahLike': jumlahLike,
      'jumlahShare': jumlahShare,
      if (nomorHp != null) 'nomor_hp': nomorHp,
      if (tanggalLahir != null) 'tanggal_lahir': tanggalLahir,
      // Inisialisasi 'aktivitas' jika diperlukan
      'aktivitas': FieldValue.arrayUnion([
        {'namaAktivitas': 'User registration', 'waktu': Timestamp.now()}
      ]),
    };
  }
}