import 'package:cloud_firestore/cloud_firestore.dart';

class KawanssLikeModel {
  final String id; // Document ID
  final String kawanssUid; // Field name is 'kawanssUid' - check if it's 'kawanssId'
  final DateTime timestamp;
  final String userId;

  KawanssLikeModel({
    required this.id,
    required this.kawanssUid,
    required this.timestamp,
    required this.userId,
  });

  factory KawanssLikeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return KawanssLikeModel(
      id: snapshot.id,
      kawanssUid: data?['kawanssUid'] ?? data?['kawanssId'] ?? '', // Handle potential variations
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data?['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'kawanssUid': kawanssUid, // Use the correct field name when writing
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
    };
  }
}