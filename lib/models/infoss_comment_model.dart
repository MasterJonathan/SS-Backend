import 'package:cloud_firestore/cloud_firestore.dart';

class InfossCommentModel {
  final String id; // Document ID
  final String comment;
  final bool deleted;
  final List<String>? dislikedUsers; // Assuming array of user IDs
  final String infossId;
  final int jumlahDislike;
  final int jumlahLike;
  final int jumlahReplies;
  final List<String>? likedUsers; // Assuming array of user IDs
  final String? photoURL;
  final DateTime uploadDate;
  final String userId;
  final String username;
  // Consider a 'replies' field if it's an array of nested comment objects,
  // or handle as a subcollection separately.

  InfossCommentModel({
    required this.id,
    required this.comment,
    required this.deleted,
    this.dislikedUsers,
    required this.infossId,
    required this.jumlahDislike,
    required this.jumlahLike,
    required this.jumlahReplies,
    this.likedUsers,
    this.photoURL,
    required this.uploadDate,
    required this.userId,
    required this.username,
  });

  factory InfossCommentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return InfossCommentModel(
      id: snapshot.id,
      comment: data?['comment'] ?? '',
      deleted: data?['deleted'] ?? false,
      dislikedUsers: data?['dislikedUsers'] != null ? List<String>.from(data?['dislikedUsers']) : null,
      infossId: data?['infossId'] ?? '',
      jumlahDislike: data?['jumlahDislike'] ?? 0,
      jumlahLike: data?['jumlahLike'] ?? 0,
      jumlahReplies: data?['jumlahReplies'] ?? 0,
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
      'infossId': infossId,
      'jumlahDislike': jumlahDislike,
      'jumlahLike': jumlahLike,
      'jumlahReplies': jumlahReplies,
      if (likedUsers != null) 'likedUsers': likedUsers,
      if (photoURL != null) 'photoURL': photoURL,
      'uploadDate': Timestamp.fromDate(uploadDate),
      'userId': userId,
      'username': username,
    };
  }
}