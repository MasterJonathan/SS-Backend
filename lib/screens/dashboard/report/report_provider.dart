import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/core/services/sheets_service.dart';
import 'package:admin_dashboard_template/models/infoss_model.dart';
import 'package:admin_dashboard_template/models/kawanss_model.dart';
import 'package:admin_dashboard_template/models/kontributor_model.dart';
import 'package:admin_dashboard_template/models/news_model.dart';
import 'package:admin_dashboard_template/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TrafficTimeRange { Harian, Mingguan, Bulanan, Tahunan }
enum TrafficType { AllViews, Posts, NewUsers }

class ReportProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late final SheetsService _sheetsService;

  bool _isReady = false;
  bool get isReady => _isReady;

  bool _isStatsLoading = false;
  String? _statsErrorMessage;
  Map<String, dynamic>? _monthlyStats;
  List<InfossModel> _topPosts = [];

  bool _isTablesLoading = false;
  String? _tablesErrorMessage;
  List<dynamic> _allPosts = [];
  List<UserModel> _allUsers = [];

  bool _isTrafficLoading = false;
  String? _trafficErrorMessage;
  TrafficTimeRange _selectedTimeRange = TrafficTimeRange.Harian;
  TrafficType _selectedTrafficType = TrafficType.AllViews;
  List<double> _trafficData = [];
  List<String> _trafficLabels = [];
  String _trafficChartTitle = "Rata-rata Traffic 24 Jam Terakhir";
  
  bool _isExportingPosts = false;
  String? _exportPostsMessage;
  bool _isExportingUsers = false;
  String? _exportUsersMessage;

  bool get isStatsLoading => _isStatsLoading;
  String? get statsErrorMessage => _statsErrorMessage;
  Map<String, dynamic>? get monthlyStats => _monthlyStats;
  List<InfossModel> get topPosts => _topPosts;

  bool get isTablesLoading => _isTablesLoading;
  String? get tablesErrorMessage => _tablesErrorMessage;
  List<dynamic> get allPosts => _allPosts;
  List<UserModel> get allUsers => _allUsers;

  bool get isTrafficLoading => _isTrafficLoading;
  String? get trafficErrorMessage => _trafficErrorMessage;
  TrafficTimeRange get selectedTimeRange => _selectedTimeRange;
  TrafficType get selectedTrafficType => _selectedTrafficType;
  List<double> get trafficData => _trafficData;
  List<String> get trafficLabels => _trafficLabels;
  String get trafficChartTitle => _trafficChartTitle;

  bool get isExportingPosts => _isExportingPosts;
  String? get exportPostsMessage => _exportPostsMessage;
  bool get isExportingUsers => _isExportingUsers;
  String? get exportUsersMessage => _exportUsersMessage;

  ReportProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  Future<void> init() async {
    if (_isReady) return;

    _sheetsService = await SheetsService.initialize();
    
    await Future.wait([
      fetchGeneralReports(),
      fetchTableData(),
      fetchTrafficReport(TrafficTimeRange.Harian),
    ]);
    
    _isReady = true;
    notifyListeners();
  }

  Future<void> fetchGeneralReports() async {
    _isStatsLoading = true;
    notifyListeners();
    try {
      final statsFuture = _firestoreService.getMonthlyStats();
      final topPostsFuture = _firestoreService.getTopTenPosts();

      final results = await Future.wait([statsFuture, topPostsFuture]);

      _monthlyStats = results[0] as Map<String, dynamic>;
      _topPosts = results[1] as List<InfossModel>;
    } catch (e) {
      _statsErrorMessage = "Gagal memuat laporan umum: $e";
    } finally {
      _isStatsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTableData() async {
    _isTablesLoading = true;
    notifyListeners();
    try {
        final newsFuture = _firestoreService.getNewsStream().first;
        final kawanSsFuture = _firestoreService.getKawanssStream().first;
        final kontributorFuture = _firestoreService.getKontributorsStream().first;
        final usersFuture = _firestoreService.getUsersStream().first;

        final results = await Future.wait([
            newsFuture,
            kawanSsFuture,
            kontributorFuture,
            usersFuture,
        ]);

        final List<NewsModel> news = results[0] as List<NewsModel>;
        final List<KawanssModel> kawanss = results[1] as List<KawanssModel>;
        final List<KontributorModel> kontributor = results[2] as List<KontributorModel>;
        _allUsers = results[3] as List<UserModel>;

        _allPosts = [...news, ...kawanss, ...kontributor];
        _allPosts.sort((a, b) {
            DateTime dateA = (a is NewsModel) ? a.uploadDate! : (a is KawanssModel ? a.uploadDate : (a as KontributorModel).uploadDate);
            DateTime dateB = (b is NewsModel) ? b.uploadDate! : (b is KawanssModel ? b.uploadDate : (b as KontributorModel).uploadDate);
            return dateB.compareTo(dateA);
        });

    } catch(e) {
        _tablesErrorMessage = "Gagal memuat data tabel: $e";
    } finally {
        _isTablesLoading = false;
        notifyListeners();
    }
  }

  Future<void> fetchTrafficReport(TrafficTimeRange range, {TrafficType? type}) async {
    _isTrafficLoading = true;
    _selectedTimeRange = range;
    if (type != null) {
      _selectedTrafficType = type;
    }
    notifyListeners();

    try {
      final now = DateTime.now();
      DateTime startTime;
      
      switch (range) {
        case TrafficTimeRange.Harian:
          startTime = now.subtract(const Duration(hours: 24));
          break;
        case TrafficTimeRange.Mingguan:
          startTime = now.subtract(const Duration(days: 7));
          break;
        case TrafficTimeRange.Bulanan:
          startTime = DateTime(now.year, now.month, 1);
          break;
        case TrafficTimeRange.Tahunan:
          startTime = DateTime(now.year, 1, 1);
          break;
      }

      List<DateTime> rawData;
      String titleSegment = "";
      
      switch (_selectedTrafficType) {
        case TrafficType.Posts:
          rawData = await _firestoreService.getPostsTraffic(startTime, now);
          titleSegment = "Postingan Baru";
          break;
        case TrafficType.NewUsers:
          rawData = await _firestoreService.getNewUsersTraffic(startTime, now);
          titleSegment = "Pengguna Baru";
          break;
        case TrafficType.AllViews:
        default:
          rawData = await _firestoreService.getTrafficDataInRange(startTime, now);
          titleSegment = "Semua Kunjungan";
          break;
      }
      
      _processTrafficData(rawData, range);
      
      String rangeName = toBeginningOfSentenceCase(range.name.toLowerCase()) ?? range.name;
      _trafficChartTitle = "Traffic $titleSegment - $rangeName";

    } catch (e) {
      _trafficErrorMessage = "Gagal memuat data traffic: $e";
      _trafficData = [];
      _trafficLabels = [];
    } finally {
      _isTrafficLoading = false;
      notifyListeners();
    }
  }

  void _processTrafficData(List<DateTime> timestamps, TrafficTimeRange range) {
    if (timestamps.isEmpty) {
      _trafficData = [];
      _trafficLabels = [];
      return;
    }
    Map<int, int> counts = {};
    switch (range) {
      case TrafficTimeRange.Harian:
        for (var t in timestamps) counts.update(t.hour, (v) => v + 1, ifAbsent: () => 1);
        _trafficData = List.generate(24, (i) => (counts[i] ?? 0).toDouble());
        _trafficLabels = List.generate(24, (i) => i.toString().padLeft(2, '0'));
        break;
      case TrafficTimeRange.Mingguan:
        final now = DateTime.now();
        for (var t in timestamps) {
          int dayIndex = 6 - now.difference(DateTime(t.year, t.month, t.day)).inDays;
          if (dayIndex >= 0 && dayIndex < 7) counts.update(dayIndex, (v) => v + 1, ifAbsent: () => 1);
        }
        _trafficData = List.generate(7, (i) => (counts[i] ?? 0).toDouble());
        _trafficLabels = List.generate(7, (i) => DateFormat('E', 'id_ID').format(now.subtract(Duration(days: 6 - i))));
        break;
      case TrafficTimeRange.Bulanan:
        final daysInMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
        for (var t in timestamps) counts.update(t.day, (v) => v + 1, ifAbsent: () => 1);
        _trafficData = List.generate(daysInMonth, (i) => (counts[i + 1] ?? 0).toDouble());
        _trafficLabels = List.generate(daysInMonth, (i) => (i + 1).toString());
        break;
      case TrafficTimeRange.Tahunan:
        for (var t in timestamps) counts.update(t.month, (v) => v + 1, ifAbsent: () => 1);
        _trafficData = List.generate(12, (i) => (counts[i + 1] ?? 0).toDouble());
        _trafficLabels = List.generate(12, (i) => DateFormat('MMM', 'id_ID').format(DateTime(0, i + 1)));
        break;
    }
  }

  Future<bool> exportPostsToSheet() async {
    if (!_isReady) {
      _exportPostsMessage = "Gagal: Layanan Google Sheets belum siap. Coba lagi sesaat.";
      notifyListeners();
      return false;
    }

    _isExportingPosts = true;
    _exportPostsMessage = "Memulai ekspor...";
    notifyListeners();

    try {
      if (_allPosts.isEmpty) {
        _exportPostsMessage = "Gagal: Tidak ada data postingan untuk diekspor.";
        _isExportingPosts = false;
        notifyListeners();
        return false;
      }

      const spreadsheetId = '1F2obOikLOn92ewLwLlPhmVdhAW19EO15CcOZG_rtOWc';
      const worksheetTitle = 'Post';

      final worksheet = await _sheetsService.getWorksheet(spreadsheetId, worksheetTitle);
      if (worksheet == null) {
          _exportPostsMessage = "Gagal: Worksheet '$worksheetTitle' tidak ditemukan atau tidak bisa dibuat.";
          _isExportingPosts = false;
          notifyListeners();
          return false;
      }
      
      await _sheetsService.clearWorksheet(worksheet);

      final headers = ['Judul', 'Tipe', 'Tanggal Posting', 'Oleh', 'Dilihat', 'Likes', 'Comments'];
      await _sheetsService.insertRow(worksheet, 1, headers);

      List<List<dynamic>> rows = [];
      for (var post in _allPosts) {
        String title = '';
        String type = '';
        String date = '';
        String author = '';
        int views = 0;
        int likes = 0;
        int comments = 0;

        if (post is NewsModel) {
            title = post.title!; type = 'Berita Web'; date = post.uploadDate!.toIso8601String();
            author = post.pengirim!; views = post.jumlahView!; likes = post.jumlahLike!; comments = 0;
        } else if (post is KawanssModel) {
            title = post.title ?? 'Tanpa Judul'; type = 'Kawan SS'; date = post.uploadDate.toIso8601String();
            author = post.accountName ?? 'Anonim'; views = post.jumlahLaporan; likes = post.jumlahLike; comments = post.jumlahComment;
        } else if (post is KontributorModel) {
            title = post.judul ?? post.deskripsi ?? 'Tanpa Judul'; type = 'Kontributor'; date = post.uploadDate.toIso8601String();
            author = post.accountName ?? 'Anonim'; views = post.jumlahLaporan; likes = post.jumlahLike; comments = post.jumlahComment;
        }
        rows.add([title, type, date, author, views, likes, comments]);
      }
      
      await _sheetsService.appendRows(worksheet, rows);
      
      _exportPostsMessage = "Berhasil mengekspor ${rows.length} data postingan!";
      return true;

    } catch (e) {
      _exportPostsMessage = "Terjadi kesalahan fatal saat ekspor: $e";
      return false;
    } finally {
      _isExportingPosts = false;
      notifyListeners();
    }
  }

  Future<bool> exportUsersToSheet() async {
     if (!_isReady) {
      _exportUsersMessage = "Gagal: Layanan Google Sheets belum siap. Coba lagi sesaat.";
      notifyListeners();
      return false;
    }

    _isExportingUsers = true;
    _exportUsersMessage = "Memulai ekspor...";
    notifyListeners();

    try {
        if (_allUsers.isEmpty) {
          _exportUsersMessage = "Gagal: Tidak ada data pengguna untuk diekspor.";
          _isExportingUsers = false;
          notifyListeners();
          return false;
        }

        const spreadsheetId = '1F2obOikLOn92ewLwLlPhmVdhAW19EO15CcOZG_rtOWc';
        const worksheetTitle = 'Users';

        final worksheet = await _sheetsService.getWorksheet(spreadsheetId, worksheetTitle);
        if (worksheet == null) {
          _exportUsersMessage = "Gagal: Worksheet '$worksheetTitle' tidak ditemukan atau tidak bisa dibuat.";
          _isExportingUsers = false;
          notifyListeners();
          return false;
        }
        
        await _sheetsService.clearWorksheet(worksheet);

        final headers = ['Nama', 'Email', 'Role', 'Tanggal Bergabung', 'Status'];
        await _sheetsService.insertRow(worksheet, 1, headers);

        _allUsers.sort((a, b) => b.joinDate.compareTo(a.joinDate));

        List<List<dynamic>> rows = _allUsers.map((user) => [
            user.nama, user.email, user.role, user.joinDate.toIso8601String(), user.status ? 'Aktif' : 'Nonaktif',
        ]).toList();
        
        await _sheetsService.appendRows(worksheet, rows);

        _exportUsersMessage = "Berhasil mengekspor ${rows.length} data pengguna!";
        return true;
    } catch(e) {
        _exportUsersMessage = "Terjadi kesalahan fatal saat ekspor: $e";
        return false;
    } finally {
        _isExportingUsers = false;
        notifyListeners();
    }
  }
}