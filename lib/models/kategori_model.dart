import 'package:cloud_firestore/cloud_firestore.dart';

class KategoriModel {
  final String id; 
  final String namaKategori; 
                           
                           

  KategoriModel({
    required this.id,
    required this.namaKategori,
  });

  factory KategoriModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    
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
    
    
    return {
      'namaKategori': namaKategori,
    };
  }
}