import 'package:admin_dashboard_template/core/utils/constants.dart';
import 'package:admin_dashboard_template/models/banner_model.dart';
import 'package:admin_dashboard_template/models/infoss_comment_model.dart';
import 'package:admin_dashboard_template/models/kawanss_model.dart';
import 'package:admin_dashboard_template/models/kontributor_model.dart';
import 'package:admin_dashboard_template/models/news_model.dart';
import 'package:admin_dashboard_template/models/settings_model.dart';
import 'package:admin_dashboard_template/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> getUsersStream() {
    return _db
        .collection(USERS_COLLECTION)
        .orderBy('nama', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => UserModel.fromFirestore(doc, null))
                  .toList(),
        );
  }

  Future<UserModel?> getUser(String uid) async {
    final docRef = _db.collection(USERS_COLLECTION).doc(uid);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      return UserModel.fromFirestore(docSnap, null);
    }
    // Jika dokumen tidak ada, kembalikan null
    return null;
  }

  Future<void> setUserProfile(UserModel user) {
    return _db
        .collection(USERS_COLLECTION)
        .doc(user.id)
        .set(user.toFirestore());
  }

  Future<void> addUser(UserModel user) {
    return _db
        .collection(USERS_COLLECTION)
        .doc(user.id)
        .set(user.toFirestore());
  }

  Future<void> updateUser(UserModel user) {
    return _db
        .collection(USERS_COLLECTION)
        .doc(user.id)
        .update(user.toFirestore());
  }

  Future<void> updateUserPartial(String userId, Map<String, dynamic> data) {
    return _db.collection(USERS_COLLECTION).doc(userId).update(data);
  }

  Future<void> deleteUser(String userId) {
    return _db.collection(USERS_COLLECTION).doc(userId).delete();
  }

  Stream<List<KawanssModel>> getKawanssStream() {
    return _db
        .collection(KAWANSS_COLLECTION)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => KawanssModel.fromFirestore(doc, null))
                  .toList(),
        );
  }

  Future<DocumentReference> addKawanss(KawanssModel kawanss) {
    return _db.collection(KAWANSS_COLLECTION).add(kawanss.toFirestore());
  }

  Future<void> updateKawanss(KawanssModel kawanss) {
    return _db
        .collection(KAWANSS_COLLECTION)
        .doc(kawanss.id)
        .update(kawanss.toFirestore());
  }

  Future<void> deleteKawanss(String kawanssId) {
    return _db.collection(KAWANSS_COLLECTION).doc(kawanssId).delete();
  }

  Stream<List<KontributorModel>> getKontributorsStream() {
    return _db
        .collection(KONTRIBUTOR_COLLECTION)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => KontributorModel.fromFirestore(doc, null))
                  .toList(),
        );
  }

  Future<DocumentReference> addKontributor(KontributorModel kontributor) {
    return _db
        .collection(KONTRIBUTOR_COLLECTION)
        .add(kontributor.toFirestore());
  }

  Future<void> updateKontributor(KontributorModel kontributor) {
    return _db
        .collection(KONTRIBUTOR_COLLECTION)
        .doc(kontributor.id)
        .update(kontributor.toFirestore());
  }

  Future<void> deleteKontributor(String kontributorId) {
    return _db.collection(KONTRIBUTOR_COLLECTION).doc(kontributorId).delete();
  }

  Stream<List<NewsModel>> getNewsStream() {
    return _db
        .collection(NEWS_COLLECTION)
        .orderBy('tanggalPublish', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => NewsModel.fromFirestore(doc, null))
                  .toList(),
        );
  }

  Future<DocumentReference> addNews(NewsModel news) {
    return _db.collection(NEWS_COLLECTION).add(news.toFirestore());
  }

  Future<void> updateNews(NewsModel news) {
    return _db
        .collection(NEWS_COLLECTION)
        .doc(news.id)
        .update(news.toFirestore());
  }

  Future<void> deleteNews(String newsId) {
    return _db.collection(NEWS_COLLECTION).doc(newsId).delete();
  }

  Stream<List<BannerTopModel>> getBannersStream() {
    return _db
        .collection('bannerTop')
        .orderBy('tanggalPosting', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => BannerTopModel.fromFirestore(doc, null))
                  .toList(),
        );
  }

  Future<DocumentReference> addBanner(BannerTopModel banner) {
    return _db.collection('bannerTop').add(banner.toFirestore());
  }

  Future<void> updateBanner(BannerTopModel banner) {
    return _db
        .collection('bannerTop')
        .doc(banner.id)
        .update(banner.toFirestore());
  }

  Future<void> deleteBanner(String bannerId) {
    return _db.collection('bannerTop').doc(bannerId).delete();
  }

  Stream<List<InfossCommentModel>> getInfossCommentsStream() {
    return _db
        .collection(INFOSS_COMMENTS_COLLECTION)
        .orderBy('uploadDate', descending: true)
        .limit(100)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => InfossCommentModel.fromFirestore(doc, null))
                  .toList(),
        );
  }

  Future<void> updateInfossComment(InfossCommentModel comment) {
    return _db
        .collection(INFOSS_COMMENTS_COLLECTION)
        .doc(comment.id)
        .update(comment.toFirestore());
  }

  Future<void> deleteInfossComment(String commentId) {
    return _db.collection(INFOSS_COMMENTS_COLLECTION).doc(commentId).delete();
  }

  Future<SettingsModel?> getSettings() async {
    final docRef = _db.collection('settings').doc('appConfig');
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      return SettingsModel.fromFirestore(docSnap, null);
    } else {
      return null;
    }
  }

  Future<void> updateSettings(SettingsModel settings) {
    return _db
        .collection('settings')
        .doc('appConfig')
        .set(settings.toFirestore());
  }
}
