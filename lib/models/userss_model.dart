import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // Document ID (UID from Firebase Auth usually)
  final int? aktivitas; // Assuming this is a count or flag
  final String? namaAktivitas;
  final DateTime? waktu; // Timestamp for 'namaAktivitas'
  final String? alamat;
  final String email;
  // 'id' field in Firestore doc seems to be a duplicate of document ID, handled by model's id.
  final String? jenisKelamin;
  final int jumlahComment;
  final int jumlahKontributor; // Posts made as kontributor
  final int jumlahLike;
  final int jumlahShare;
  final String nama;
  final String? nomorHp;
  final String? photoURL;
  final String role; // e.g., "User", "Admin"
  final String? tanggalLahir; // Consider DateTime if you parse it

  UserModel({
    required this.id,
    this.aktivitas,
    this.namaAktivitas,
    this.waktu,
    this.alamat,
    required this.email,
    this.jenisKelamin,
    required this.jumlahComment,
    required this.jumlahKontributor,
    required this.jumlahLike,
    required this.jumlahShare,
    required this.nama,
    this.nomorHp,
    this.photoURL,
    required this.role,
    this.tanggalLahir,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return UserModel(
      id: snapshot.id,
      aktivitas: data?['aktivitas'],
      namaAktivitas: data?['namaAktivitas'],
      waktu: (data?['waktu'] as Timestamp?)?.toDate(),
      alamat: data?['alamat'],
      email: data?['email'] ?? '',
      jenisKelamin: data?['jenis_kelamin'], // Note underscore
      jumlahComment: data?['jumlahComment'] ?? 0,
      jumlahKontributor: data?['jumlahKontributor'] ?? 0,
      jumlahLike: data?['jumlahLike'] ?? 0,
      jumlahShare: data?['jumlahShare'] ?? 0,
      nama: data?['nama'] ?? '',
      nomorHp: data?['nomor_hp'], // Note underscore
      photoURL: data?['photoURL'],
      role: data?['role'] ?? 'User',
      tanggalLahir: data?['tanggal_lahir'], // Note underscore
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (aktivitas != null) 'aktivitas': aktivitas,
      if (namaAktivitas != null) 'namaAktivitas': namaAktivitas,
      if (waktu != null) 'waktu': Timestamp.fromDate(waktu!),
      if (alamat != null) 'alamat': alamat,
      'email': email,
      if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
      'jumlahComment': jumlahComment,
      'jumlahKontributor': jumlahKontributor,
      'jumlahLike': jumlahLike,
      'jumlahShare': jumlahShare,
      'nama': nama,
      if (nomorHp != null) 'nomor_hp': nomorHp,
      if (photoURL != null) 'photoURL': photoURL,
      'role': role,
      if (tanggalLahir != null) 'tanggal_lahir': tanggalLahir,
    };
  }
}