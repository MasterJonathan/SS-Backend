import 'package:cloud_firestore/cloud_firestore.dart';

class KategoriModel {
  final String id; // Document ID
  final String namaKategori; // Field name is 'namaKategori' or 'namaKategori_1' etc.
                           // Assuming a consistent field name for simplicity.
                           // If it varies, you might need separate models or more complex parsing.

  KategoriModel({
    required this.id,
    required this.namaKategori,
  });

  factory KategoriModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    // Attempt to find the category name, accommodating slight variations if necessary
    String name = '';
    if (data != null) {
        name = data['namaKategori'] ?? data['namaKategori1'] ?? data['namaKategori_1'] ?? '';
    }
    return KategoriModel(
      id: snapshot.id,
      namaKategori: name,
    );
  }

  Map<String, dynamic> toFirestore() {
    // Assuming the field name is 'namaKategori' when writing back.
    // Adjust if different collections use different field names for the category name.
    return {
      'namaKategori': namaKategori,
    };
  }
}