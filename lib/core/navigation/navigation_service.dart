import 'package:flutter/material.dart';

// Define all possible pages/sections that can be displayed in the main content area
// of your dashboard.
enum DashboardPage {
  // Existing Pages from original example
  overview,
  users,         // Corresponds to 'User Management' in the new sidebar
  products,      // Corresponds to 'Products (Old)'
  calendar,      // Corresponds to 'Calendar (Old)'
  charts,        // Corresponds to 'Charts (Old)'
  forms,         // Corresponds to 'Forms (Old)'
  profile,

  // -----------------------------
  settings,
  userAdminManagement,

  bannerTop,
  kawanSS,

  beritaWeb,
  kontributorManagement,
  kontributorPost,

  chatManagement,



  // -------------------------

  kawanSSManagement,
  contributor,
  kontributorComment,
  postinganTerlapor,
  reportManagement,

}

class NavigationService extends ChangeNotifier {

  DashboardPage _currentPage = DashboardPage.overview;

  /// Gets the current [DashboardPage] that should be displayed.
  DashboardPage get currentPage => _currentPage;


  void navigateTo(DashboardPage page) {
    if (_currentPage != page) { // Only update and notify if the page actually changes
      _currentPage = page;
      notifyListeners();
    }
  }


}