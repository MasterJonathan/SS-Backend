import 'package:admin_dashboard_template/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // For table_calendar

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(); // For table_calendar
  runApp(const AdminDashboardApp());
}