// lib/screens/dashboard/report/report_provider.dart

import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/core/services/sheets_service.dart';
import 'package:admin_dashboard_template/models/infoss_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TrafficTimeRange { Harian, Mingguan, Bulanan, Tahunan }

class ReportProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late final SheetsService _sheetsService;

  // State untuk statistik umum dari Firestore
  bool _isStatsLoading = false;
  String? _statsErrorMessage;
  Map<String, dynamic>? _monthlyStats;
  List<InfossModel> _topPosts = [];

  // State untuk grafik traffic
  bool _isTrafficLoading = false;
  String? _trafficErrorMessage;
  TrafficTimeRange _selectedTimeRange = TrafficTimeRange.Harian;
  List<double> _trafficData = [];
  List<String> _trafficLabels = [];
  String _trafficChartTitle = "Rata-rata Traffic 24 Jam Terakhir";

  // State baru untuk data dari Google Sheets
  bool _isSheetDataLoading = false;
  String? _sheetDataErrorMessage;
  List<Map<String, String>> _sheetData = [];

  // Getters
  bool get isStatsLoading => _isStatsLoading;
  String? get statsErrorMessage => _statsErrorMessage;
  Map<String, dynamic>? get monthlyStats => _monthlyStats;
  List<InfossModel> get topPosts => _topPosts;

  bool get isTrafficLoading => _isTrafficLoading;
  String? get trafficErrorMessage => _trafficErrorMessage;
  TrafficTimeRange get selectedTimeRange => _selectedTimeRange;
  List<double> get trafficData => _trafficData;
  List<String> get trafficLabels => _trafficLabels;
  String get trafficChartTitle => _trafficChartTitle;

  bool get isSheetDataLoading => _isSheetDataLoading;
  String? get sheetDataErrorMessage => _sheetDataErrorMessage;
  List<Map<String, String>> get sheetData => _sheetData;

  ReportProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _initializeServices();
    fetchGeneralReports();
    fetchTrafficReport(TrafficTimeRange.Harian);
  }

  Future<void> _initializeServices() async {
    // Inisialisasi SheetsService. Pastikan file kredensial ada.
    _sheetsService = await SheetsService.initialize();
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

  Future<void> fetchTrafficReport(TrafficTimeRange range) async {
    _isTrafficLoading = true;
    _selectedTimeRange = range;
    notifyListeners();
    try {
      final now = DateTime.now();
      DateTime startTime;
      String newTitle = "";
      
      switch (range) {
        case TrafficTimeRange.Harian:
          startTime = now.subtract(const Duration(hours: 24));
          newTitle = "Traffic 24 Jam Terakhir (per Jam)";
          break;
        case TrafficTimeRange.Mingguan:
          startTime = now.subtract(const Duration(days: 7));
          newTitle = "Traffic 7 Hari Terakhir (per Hari)";
          break;
        case TrafficTimeRange.Bulanan:
          startTime = DateTime(now.year, now.month, 1);
          newTitle = "Traffic Bulan Ini (per Hari)";
          break;
        case TrafficTimeRange.Tahunan:
          startTime = DateTime(now.year, 1, 1);
          newTitle = "Traffic Tahun Ini (per Bulan)";
          break;
      }
      
      final rawData = await _firestoreService.getTrafficDataInRange(startTime, now);
      _processTrafficData(rawData, range);
      _trafficChartTitle = newTitle;

    } catch (e) {
      _trafficErrorMessage = "Gagal memuat data traffic: $e";
    } finally {
      _isTrafficLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk mengambil data dari Google Sheets
  Future<void> fetchSheetData() async {
    _isSheetDataLoading = true;
    _sheetDataErrorMessage = null;
    notifyListeners();
    try {
      // ID Spreadsheet sudah diganti dengan milik Anda
      const spreadsheetId = '1F2obOikLOn92ewLwLlPhmVdhAW19EO15CcOZG_rtOWc'; 
      // !!! JIKA NAMA WORKSHEET (TAB) BUKAN 'Sheet1', GANTI DI SINI !!!
      const worksheetTitle = 'Sheet1'; 

      final worksheet = await _sheetsService.getWorksheet(spreadsheetId, worksheetTitle);
      if (worksheet != null) {
        final data = await _sheetsService.getRowsAsMaps(worksheet);
        _sheetData = data ?? [];
        if (_sheetData.isEmpty) {
          _sheetDataErrorMessage = "Worksheet ditemukan, namun tidak ada data.";
        }
      } else {
        _sheetDataErrorMessage = "Worksheet tidak ditemukan. Periksa ID, nama worksheet, dan pastikan sudah di-share ke service account.";
      }
    } catch (e) {
      _sheetDataErrorMessage = "Gagal memuat data dari Sheets: $e";
    } finally {
      _isSheetDataLoading = false;
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
        _trafficLabels = List.generate(24, (i) => i.toString());
        break;
      case TrafficTimeRange.Mingguan:
        final now = DateTime.now();
        for (var t in timestamps) {
          int dayIndex = 6 - now.difference(DateTime(t.year, t.month, t.day)).inDays;
          if (dayIndex >= 0 && dayIndex < 7) counts.update(dayIndex, (v) => v + 1, ifAbsent: () => 1);
        }
        _trafficData = List.generate(7, (i) => (counts[i] ?? 0).toDouble());
        _trafficLabels = List.generate(7, (i) => DateFormat('E').format(now.subtract(Duration(days: 6 - i))));
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
        _trafficLabels = List.generate(12, (i) => DateFormat('MMM').format(DateTime(0, i + 1)));
        break;
    }
  }
}