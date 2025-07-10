import 'package:cloud_firestore/cloud_firestore.dart';

class KawanssLikeModel {
  final String id; 
  final String kawanssUid; 
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
      kawanssUid: data?['kawanssUid'] ?? data?['kawanssId'] ?? '', 
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data?['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'kawanssUid': kawanssUid, 
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
    };
  }
}