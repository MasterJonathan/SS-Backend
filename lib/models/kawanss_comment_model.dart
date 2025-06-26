import 'package:cloud_firestore/cloud_firestore.dart';

class KawanssCommentModel {
  final String id; // Document ID
  final String comment;
  final bool deleted;
  final List<String>? dislikedUsers;
  final int jumlahDislike;
  final int jumlahLike;
  final int jumlahReplies;
  final String kawanssId; // Field name is 'kawanssId'
  final List<String>? likedUsers;
  final String? photoURL;
  final DateTime uploadDate;
  final String userId;
  final String username;

  KawanssCommentModel({
    required this.id,
    required this.comment,
    required this.deleted,
    this.dislikedUsers,
    required this.jumlahDislike,
    required this.jumlahLike,
    required this.jumlahReplies,
    required this.kawanssId,
    this.likedUsers,
    this.photoURL,
    required this.uploadDate,
    required this.userId,
    required this.username,
  });

  factory KawanssCommentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return KawanssCommentModel(
      id: snapshot.id,
      comment: data?['comment'] ?? '',
      deleted: data?['deleted'] ?? false,
      dislikedUsers: data?['dislikedUsers'] != null ? List<String>.from(data?['dislikedUsers']) : null,
      jumlahDislike: data?['jumlahDislike'] ?? 0,
      jumlahLike: data?['jumlahLike'] ?? 0,
      jumlahReplies: data?['jumlahReplies'] ?? 0,
      kawanssId: data?['kawanssId'] ?? '',
      likedUsers: data?['likedUsers'] != null ? List<String>.from(data?['likedUsers']) : null,
      photoURL: data?['photoURL'],
      uploadDate: (data?['uploadDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data?['userId'] ?? '',
      username: data?['username'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'comment': comment,
      'deleted': deleted,
      if (dislikedUsers != null) 'dislikedUsers': dislikedUsers,
      'jumlahDislike': jumlahDislike,
      'jumlahLike': jumlahLike,
      'jumlahReplies': jumlahReplies,
      'kawanssId': kawanssId,
      if (likedUsers != null) 'likedUsers': likedUsers,
      if (photoURL != null) 'photoURL': photoURL,
      'uploadDate': Timestamp.fromDate(uploadDate),
      'userId': userId,
      'username': username,
    };
  }
}