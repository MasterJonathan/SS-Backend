// lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String nama;
  final String role;
  final bool isActive; // ✨ FIELD BARU UNTUK STATUS AKTIF/INAKTIF
  final DateTime? waktu; // Akan kita gunakan sebagai Tanggal Registrasi
  final String? photoURL;
  // Field lain tetap ada
  final int? aktivitas;
  final String? namaAktivitas;
  final String? alamat;
  final String? jenisKelamin;
  final int jumlahComment;
  final int jumlahKontributor;
  final int jumlahLike;
  final int jumlahShare;
  final String? nomorHp;
  final String? tanggalLahir;

  UserModel({
    required this.id,
    required this.email,
    required this.nama,
    required this.role,
    required this.isActive, // ✨ Tambahkan di constructor
    this.waktu,
    this.photoURL,
    this.aktivitas,
    this.namaAktivitas,
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
      nama: data?['nama'] ?? '',
      role: data?['role'] ?? 'User',
      isActive: data?['isActive'] ?? true, // ✨ Ambil data, default ke true (Aktif)
      waktu: (data?['waktu'] as Timestamp?)?.toDate(),
      photoURL: data?['photoURL'],
      aktivitas: data?['aktivitas'],
      namaAktivitas: data?['namaAktivitas'],
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
      'isActive': isActive, // ✨ Tambahkan saat menyimpan
      if (waktu != null) 'waktu': Timestamp.fromDate(waktu!),
      if (photoURL != null) 'photoURL': photoURL,
      if (aktivitas != null) 'aktivitas': aktivitas,
      if (namaAktivitas != null) 'namaAktivitas': namaAktivitas,
      if (alamat != null) 'alamat': alamat,
      if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
      'jumlahComment': jumlahComment,
      'jumlahKontributor': jumlahKontributor,
      'jumlahLike': jumlahLike,
      'jumlahShare': jumlahShare,
      if (nomorHp != null) 'nomor_hp': nomorHp,
      if (tanggalLahir != null) 'tanggal_lahir': tanggalLahir,
    };
  }
}