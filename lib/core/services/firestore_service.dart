// lib/core/services/firestore_service.dart

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

  // --- Metode untuk Koleksi Users ---

  Stream<List<UserModel>> getUsersStream() {
    return _db
        .collection(USERS_COLLECTION)
        .orderBy('nama', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc, null))
            .toList());
  }
  
  Future<UserModel?> getUser(String uid) async {
    final docSnap = await _db.collection(USERS_COLLECTION).doc(uid).get();
    if (docSnap.exists) {
      return UserModel.fromFirestore(docSnap, null);
    }
    return null;
  }

  Future<void> addUser(UserModel user) {
    return _db.collection(USERS_COLLECTION).doc(user.id).set(user.toFirestore());
  }

  Future<void> updateUser(UserModel user) { // Ini untuk update penuh dari dialog edit
    return _db.collection(USERS_COLLECTION).doc(user.id).update(user.toFirestore());
  }

  // ✨ METODE BARU UNTUK UPDATE SEBAGIAN FIELD
  Future<void> updateUserPartial(String userId, Map<String, dynamic> data) {
    return _db.collection(USERS_COLLECTION).doc(userId).update(data);
  }
  Future<void> deleteUser(String userId) {
    return _db.collection(USERS_COLLECTION).doc(userId).delete();
  }

  // --- Metode untuk Koleksi KawanSS ---

  Stream<List<KawanssModel>> getKawanssStream() {
    return _db
        .collection(KAWANSS_COLLECTION)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => KawanssModel.fromFirestore(doc, null))
            .toList());
  }

  Future<DocumentReference> addKawanss(KawanssModel kawanss) {
    return _db.collection(KAWANSS_COLLECTION).add(kawanss.toFirestore());
  }

  Future<void> updateKawanss(KawanssModel kawanss) {
    return _db.collection(KAWANSS_COLLECTION).doc(kawanss.id).update(kawanss.toFirestore());
  }

  Future<void> deleteKawanss(String kawanssId) {
    return _db.collection(KAWANSS_COLLECTION).doc(kawanssId).delete();
  }

  // --- Metode untuk Koleksi Kontributor ---

  Stream<List<KontributorModel>> getKontributorsStream() {
    return _db
        .collection(KONTRIBUTOR_COLLECTION)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => KontributorModel.fromFirestore(doc, null))
            .toList());
  }

  Future<DocumentReference> addKontributor(KontributorModel kontributor) {
    return _db.collection(KONTRIBUTOR_COLLECTION).add(kontributor.toFirestore());
  }

  Future<void> updateKontributor(KontributorModel kontributor) {
    return _db.collection(KONTRIBUTOR_COLLECTION).doc(kontributor.id).update(kontributor.toFirestore());
  }

  Future<void> deleteKontributor(String kontributorId) {
    return _db.collection(KONTRIBUTOR_COLLECTION).doc(kontributorId).delete();
  }

  // --- Metode untuk Koleksi News --- (BARU)

  Stream<List<NewsModel>> getNewsStream() {
    return _db
        .collection(NEWS_COLLECTION)
        .orderBy('tanggalPublish', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NewsModel.fromFirestore(doc, null))
            .toList());
  }

  Future<DocumentReference> addNews(NewsModel news) {
    return _db.collection(NEWS_COLLECTION).add(news.toFirestore());
  }

  Future<void> updateNews(NewsModel news) {
    return _db.collection(NEWS_COLLECTION).doc(news.id).update(news.toFirestore());
  }

  Future<void> deleteNews(String newsId) {
    return _db.collection(NEWS_COLLECTION).doc(newsId).delete();
  }

  // --- Metode untuk Koleksi Banner --- (BARU)
  // Menggunakan nama koleksi generik, sesuaikan dengan nama koleksi banner Anda
  // Misalnya, 'bannerTop' atau 'banners'
  Stream<List<BannerTopModel>> getBannersStream() {
    return _db
        .collection('bannerTop') // Ganti dengan nama koleksi banner Anda
        .orderBy('tanggalPosting', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BannerTopModel.fromFirestore(doc, null))
            .toList());
  }

  Future<DocumentReference> addBanner(BannerTopModel banner) {
    return _db.collection('bannerTop').add(banner.toFirestore());
  }

  Future<void> updateBanner(BannerTopModel banner) {
    return _db.collection('bannerTop').doc(banner.id).update(banner.toFirestore());
  }

  Future<void> deleteBanner(String bannerId) {
    return _db.collection('bannerTop').doc(bannerId).delete();
  }

  Stream<List<InfossCommentModel>> getInfossCommentsStream() {
    return _db
        .collection(INFOSS_COMMENTS_COLLECTION)
        .orderBy('uploadDate', descending: true)
        .limit(100) // Batasi jumlah komentar yang diambil untuk performa
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InfossCommentModel.fromFirestore(doc, null))
            .toList());
  }

  Future<void> updateInfossComment(InfossCommentModel comment) {
    return _db.collection(INFOSS_COMMENTS_COLLECTION).doc(comment.id).update(comment.toFirestore());
  }

  Future<void> deleteInfossComment(String commentId) {
    return _db.collection(INFOSS_COMMENTS_COLLECTION).doc(commentId).delete();
  }


  Future<SettingsModel?> getSettings() async {
    // Ambil referensi dokumen secara langsung
    final docRef = _db.collection('settings').doc('appConfig');
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      // Jika dokumen ada, konversi ke SettingsModel
      return SettingsModel.fromFirestore(docSnap, null);
    } else {
      // Jika dokumen belum ada, bisa return null atau objek SettingsModel default
      // Return null lebih baik agar UI tahu data belum ada
      return null; 
    }
  }

  Future<void> updateSettings(SettingsModel settings) {
    // Gunakan .set() untuk membuat dokumen jika belum ada, atau menimpa jika sudah ada.
    // Ini memastikan dokumen pengaturan selalu ada setelah update pertama.
    return _db.collection('settings').doc('appConfig').set(settings.toFirestore());
  }




}

