import 'package:cloud_firestore/cloud_firestore.dart';

class NewsLikeModel {
  final String id; 
  final String newsId;
  final DateTime timestamp;
  final String userId;

  NewsLikeModel({
    required this.id,
    required this.newsId,
    required this.timestamp,
    required this.userId,
  });

  factory NewsLikeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return NewsLikeModel(
      id: snapshot.id,
      newsId: data?['newsId'] ?? '',
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data?['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'newsId': newsId,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
    };
  }
}