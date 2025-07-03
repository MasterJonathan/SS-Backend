// lib/models/news_model.dart

class NewsModel {
  final String id;
  final String judul;
  final String lead; // Paragraf singkat
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
}