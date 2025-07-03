import 'package:cloud_firestore/cloud_firestore.dart';

class InfossLikeModel {
  final String id; // Document ID
  final String infossId;
  final DateTime timestamp;
  final String userId;

  InfossLikeModel({
    required this.id,
    required this.infossId,
    required this.timestamp,
    required this.userId,
  });

  factory InfossLikeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return InfossLikeModel(
      id: snapshot.id,
      infossId: data?['infossId'] ?? '',
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data?['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'infossId': infossId,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
    };
  }
}