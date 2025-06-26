import 'package:cloud_firestore/cloud_firestore.dart';

class KontributorLikeModel {
  final String id; // Document ID
  final String kontributorUid; // Field name is 'kontributorUid'
  final DateTime timestamp;
  final String userId;

  KontributorLikeModel({
    required this.id,
    required this.kontributorUid,
    required this.timestamp,
    required this.userId,
  });

  factory KontributorLikeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return KontributorLikeModel(
      id: snapshot.id,
      kontributorUid: data?['kontributorUid'] ?? '',
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data?['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'kontributorUid': kontributorUid,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
    };
  }
}