import 'package:cloud_firestore/cloud_firestore.dart';

class KontributorCommentModel {
  final String id; 
  final String comment;
  final bool deleted;
  final String kontributorId; 
  final String? photoURL;
  final DateTime uploadDate;
  final String username; 
  

  KontributorCommentModel({
    required this.id,
    required this.comment,
    required this.deleted,
    required this.kontributorId,
    this.photoURL,
    required this.uploadDate,
    required this.username,
  });

  factory KontributorCommentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return KontributorCommentModel(
      id: snapshot.id,
      comment: data?['comment'] ?? '',
      deleted: data?['deleted'] ?? false,
      kontributorId: data?['kontributorId'] ?? '',
      photoURL: data?['photoURL'],
      uploadDate: (data?['uploadDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      username: data?['username'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'comment': comment,
      'deleted': deleted,
      'kontributorId': kontributorId,
      if (photoURL != null) 'photoURL': photoURL,
      'uploadDate': Timestamp.fromDate(uploadDate),
      'username': username,
    };
  }
}