

import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final String judul;
  final String lead;
  final DateTime tanggalPublish;
  final String category;
  final int dilihat;
  final int like;
  final bool status;
  final DateTime tanggalPosting;
  final String dipostingOleh;

  NewsModel({
    required this.id,
    required this.judul,
    required this.lead,
    required this.tanggalPublish,
    required this.category,
    required this.dilihat,
    required this.like,
    required this.status,
    required this.tanggalPosting,
    required this.dipostingOleh,
  });

  factory NewsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return NewsModel(
      id: snapshot.id,
      judul: data?['judul'] ?? '',
      lead: data?['lead'] ?? '',
      tanggalPublish: (data?['tanggalPublish'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: data?['category'] ?? '',
      dilihat: data?['dilihat'] ?? 0,
      like: data?['like'] ?? 0,
      status: data?['status'] ?? false,
      tanggalPosting: (data?['tanggalPosting'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dipostingOleh: data?['dipostingOleh'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'judul': judul,
      'lead': lead,
      'tanggalPublish': Timestamp.fromDate(tanggalPublish),
      'category': category,
      'dilihat': dilihat,
      'like': like,
      'status': status,
      'tanggalPosting': Timestamp.fromDate(tanggalPosting),
      'dipostingOleh': dipostingOleh,
    };
  }
}