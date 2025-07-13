import 'package:admin_dashboard_template/core/utils/constants.dart';
import 'package:admin_dashboard_template/models/banner_model.dart';
import 'package:admin_dashboard_template/models/infoss_comment_model.dart';
import 'package:admin_dashboard_template/models/infoss_model.dart';
import 'package:admin_dashboard_template/models/kategori_model.dart';
import 'package:admin_dashboard_template/models/kawanss_model.dart';
import 'package:admin_dashboard_template/models/kontributor_model.dart';
import 'package:admin_dashboard_template/models/news_model.dart';
import 'package:admin_dashboard_template/models/settings_model.dart';
import 'package:admin_dashboard_template/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
        .where('title', isNotEqualTo: null)
        .where('title', isNotEqualTo: '')
        .orderBy('title') 
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NewsModel.fromFirestore(doc, null))
            .toList());
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

  // Mengambil data dari koleksi tertentu
  Stream<List<KategoriModel>> getKategoriStream(String collectionName) {
    return _db
        .collection(collectionName)
        .orderBy('namaKategori')
        .snapshots()
        .map((snapshot) => snapshot.docs
            // Teruskan collectionName ke fromFirestore
            .map((doc) => KategoriModel.fromFirestore(doc, collectionName))
            .toList());
  }

  // Menambah data ke koleksi tertentu
  Future<void> addKategori(String collectionName, KategoriModel kategori) {
    return _db.collection(collectionName).add(kategori.toFirestore());
  }

  // Menghapus data dari koleksi tertentu
  Future<void> deleteKategori(String collectionName, String kategoriId) {
    return _db.collection(collectionName).doc(kategoriId).delete();
  }

  // --- Metode untuk Koleksi Infoss --- (BARU)

  Stream<List<InfossModel>> getInfossStream() {
    return _db
        .collection(INFOSS_COLLECTION)
        .orderBy(
          'uploadDate',
          descending: true,
        ) // Urutkan berdasarkan tanggal terbaru
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => InfossModel.fromFirestore(doc, null))
                  .toList(),
        );
  }

  Future<DocumentReference> addInfoss(InfossModel infoss) {
    // Menggunakan .add() agar Firestore membuat ID unik secara otomatis
    return _db.collection(INFOSS_COLLECTION).add(infoss.toFirestore());
  }

  Future<void> updateInfoss(InfossModel infoss) {
    return _db
        .collection(INFOSS_COLLECTION)
        .doc(infoss.id)
        .update(infoss.toFirestore());
  }

  Future<void> deleteInfoss(String infossId) {
    return _db.collection(INFOSS_COLLECTION).doc(infossId).delete();
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

  Future<Map<String, dynamic>> getMonthlyStats() async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final sixtyDaysAgo = now.subtract(const Duration(days: 60));

    final totalUsers =
        (await _db.collection(USERS_COLLECTION).count().get()).count ?? 0;

    final allUsersSnapshot = await _db.collection(USERS_COLLECTION).get();

    int newUsersCount = 0;
    int previousNewUsersCount = 0;

    for (var doc in allUsersSnapshot.docs) {
      final user = UserModel.fromFirestore(doc, null);
      if (user.joinDate != null) {
        if (user.joinDate!.isAfter(thirtyDaysAgo)) {
          newUsersCount++;
        }
        if (user.joinDate!.isAfter(sixtyDaysAgo) &&
            user.joinDate!.isBefore(thirtyDaysAgo)) {
          previousNewUsersCount++;
        }
      }
    }

    double newUsersChange = 0;
    if (previousNewUsersCount > 0) {
      newUsersChange =
          ((newUsersCount - previousNewUsersCount) / previousNewUsersCount) *
          100;
    } else if (newUsersCount > 0) {
      newUsersChange = 100.0;
    }

    final newsCount =
        (await _db.collection(NEWS_COLLECTION).count().get()).count ?? 0;
    final kawanssCount =
        (await _db.collection(KAWANSS_COLLECTION).count().get()).count ?? 0;
    final kontributorCount =
        (await _db.collection(KONTRIBUTOR_COLLECTION).count().get()).count ?? 0;
    final totalPosts = newsCount + kawanssCount + kontributorCount;

    int newPosts = 0;
    final collections = [
      NEWS_COLLECTION,
      KAWANSS_COLLECTION,
      KONTRIBUTOR_COLLECTION,
    ];
    for (var collection in collections) {
      final snapshot = await _db.collection(collection).get();
      for (var doc in snapshot.docs) {
        DateTime? date;
        if (collection == NEWS_COLLECTION)
          date = NewsModel.fromFirestore(doc, null).uploadDate;
        if (collection == KAWANSS_COLLECTION)
          date = KawanssModel.fromFirestore(doc, null).uploadDate;
        if (collection == KONTRIBUTOR_COLLECTION)
          date = KontributorModel.fromFirestore(doc, null).uploadDate;
        if (date != null && date.isAfter(thirtyDaysAgo)) newPosts++;
      }
    }

    return {
      'totalUsers': totalUsers,
      'newUsers': newUsersCount,
      'newUsersChange': newUsersChange,
      'totalPosts': totalPosts,
      'newPosts': newPosts,
    };
  }

  Future<List<InfossModel>> getTopTenPosts() async {
    final snapshot =
        await _db
            .collection(INFOSS_COLLECTION)
            .orderBy('jumlahView', descending: true)
            .limit(10)
            .get();

    return snapshot.docs
        .map((doc) => InfossModel.fromFirestore(doc, null))
        .toList();
  }

  Future<List<DateTime>> getTrafficDataInRange(
    DateTime startTime,
    DateTime endTime,
  ) async {
    final snapshot = await _db.collection('view_analytics').get();

    final List<DateTime> timestamps = [];
    for (var doc in snapshot.docs) {
      try {
        final tsField = doc.get('timestamp');
        DateTime? ts;

        if (tsField is Timestamp) {
          ts = tsField.toDate();
        } else if (tsField is String) {
          try {
            if (tsField.contains('/')) {
              ts = DateFormat('MM/dd/yyyy HH:mm').parse(tsField);
            } else {
              ts = DateTime.parse(tsField);
            }
          } catch (e) {
            print('Gagal mem-parsing string tanggal: "$tsField". Error: $e');
            ts = null;
          }
        }

        if (ts != null && ts.isAfter(startTime) && ts.isBefore(endTime)) {
          timestamps.add(ts);
        }
      } catch (e) {
        print(
          "Melewatkan dokumen dengan format timestamp tidak valid: ${doc.id}. Error: $e",
        );
      }
    }
    return timestamps;
  }
}
