import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // === BAGIAN FIELD YANG SUDAH FINAL ===
  // Dari PDF
  final String username; // Seringkali sama dengan 'nama' atau bagian dari 'email'
  final String role;
  final bool status; // Misal: "Aktif", "Belum Diaktifkan"
  final DateTime joinDate; // Menggunakan DateTime untuk tanggal

  // Dari DB ORI
  final String id; // ID Dokumen
  final String email;
  final String nama;
  final String? alamat;
  final String? jenisKelamin;
  final int jumlahComment;
  final int jumlahKontributor;
  final int jumlahLike;
  final int jumlahShare;
  final String? nomorHp;
  final String? photoURL;
  final String? tanggalLahir;
  // ===================================

  UserModel({
    // Wajib diisi (required)
    required this.id,
    required this.username,
    required this.role,
    required this.status,
    required this.joinDate,
    required this.email,
    required this.nama,
    required this.jumlahComment,
    required this.jumlahKontributor,
    required this.jumlahLike,
    required this.jumlahShare,
    // Opsional (nullable)
    this.alamat,
    this.jenisKelamin,
    this.nomorHp,
    this.photoURL,
    this.tanggalLahir,
  });

  // Factory constructor untuk membuat instance dari data Firestore
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    
    // Konversi Timestamp dari Firestore ke DateTime di Dart
    DateTime parsedJoinDate;
    if (data?['joinDate'] is Timestamp) {
      parsedJoinDate = (data?['joinDate'] as Timestamp).toDate();
    } else {
      // Fallback jika data joinDate belum ada, gunakan waktu sekarang
      parsedJoinDate = DateTime.now();
    }

    return UserModel(
      // Wajib
      id: snapshot.id,
      username: data?['username'] ?? data?['nama'] ?? '', // Ambil username, jika tidak ada, ambil dari 'nama'
      role: data?['role'] ?? 'User',
      status: data?['status'] ?? false,
      joinDate: parsedJoinDate,
      email: data?['email'] ?? '',
      nama: data?['nama'] ?? '',
      jumlahComment: data?['jumlahComment'] ?? 0,
      jumlahKontributor: data?['jumlahKontributor'] ?? 0,
      jumlahLike: data?['jumlahLike'] ?? 0,
      jumlahShare: data?['jumlahShare'] ?? 0,
      // Opsional
      alamat: data?['alamat'],
      jenisKelamin: data?['jenis_kelamin'],
      nomorHp: data?['nomor_hp'],
      photoURL: data?['photoURL'],
      tanggalLahir: data?['tanggal_lahir'],
    );
  }

  // Method untuk mengubah instance menjadi Map agar bisa disimpan ke Firestore
  Map<String, dynamic> toFirestore() {
    return {
      // Wajib
      'id': id,
      'username': username,
      'role': role,
      'status': status,
      'joinDate': Timestamp.fromDate(joinDate), // Simpan sebagai Timestamp
      'email': email,
      'nama': nama,
      'jumlahComment': jumlahComment,
      'jumlahKontributor': jumlahKontributor,
      'jumlahLike': jumlahLike,
      'jumlahShare': jumlahShare,
      // Opsional (hanya disimpan jika tidak null)
      if (alamat != null) 'alamat': alamat,
      if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
      if (nomorHp != null) 'nomor_hp': nomorHp,
      if (photoURL != null) 'photoURL': photoURL,
      if (tanggalLahir != null) 'tanggal_lahir': tanggalLahir,
    };
  }
}