// lib/core/services/sheets_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gsheets/gsheets.dart';

class SheetsService {
  final GSheets _gsheets;

  SheetsService(String credentialsJson) : _gsheets = GSheets(credentialsJson);

  static Future<SheetsService> initialize() async {
    final credentialsJson = await rootBundle.loadString('assets/credentials/nama_file_kredensial_anda.json'); // <-- Ganti nama file ini
    return SheetsService(credentialsJson);
  }

  Future<Worksheet?> getWorksheet(String spreadsheetId, String worksheetTitle) async {
    try {
      final ss = await _gsheets.spreadsheet(spreadsheetId);
      return ss.worksheetByTitle(worksheetTitle);
    } catch (e) {
      print('Error mendapatkan worksheet: $e');
      return null;
    }
  }

  Future<List<Map<String, String>>?> getRowsAsMaps(Worksheet worksheet) async {
     try {
      final rows = await worksheet.values.map.allRows();
      return rows;
    } catch (e) {
      print('Error mendapatkan baris: $e');
      return null;
    }
  }
}