import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id; // Document ID (e.g., "471146")
  final int jumlahComment;
  final int jumlahLike;
  final int jumlahShare;
  final int jumlahView;
  // Add other news fields like title, content, imageUrl, publishDate, category etc.
  // The screenshot only shows counts.

  NewsModel({
    required this.id,
    required this.jumlahComment,
    required this.jumlahLike,
    required this.jumlahShare,
    required this.jumlahView,
    // required String title, etc.
  });

  factory NewsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return NewsModel(
      id: snapshot.id,
      jumlahComment: data?['jumlahComment'] ?? 0,
      jumlahLike: data?['jumlahLike'] ?? 0,
      jumlahShare: data?['jumlahShare'] ?? 0,
      jumlahView: data?['jumlahView'] ?? 0,
      // title: data?['title'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'jumlahComment': jumlahComment,
      'jumlahLike': jumlahLike,
      'jumlahShare': jumlahShare,
      'jumlahView': jumlahView,
      // 'title': title,
    };
  }
}