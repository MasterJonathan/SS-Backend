import 'package:flutter/material.dart';

enum DashboardPage { overview, users, products, calendar, charts, forms, profile, socialnetworkanalysis }

class NavigationService extends ChangeNotifier {
  DashboardPage _currentPage = DashboardPage.overview;

  DashboardPage get currentPage => _currentPage;

  void navigateTo(DashboardPage page) {
    _currentPage = page;
    notifyListeners();
  }
}