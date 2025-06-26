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

  // New Pages based on the sidebar image example
  kawanSSManagement,
  beritaWeb,
  contributor,
  kontributorPost,
  kontributorComment,
  postinganTerlapor,
  chatManagement,
  reportManagement,

  // Add any other distinct pages your dashboard might have
  // Example: settings, notificationsPage, etc.
}

class NavigationService extends ChangeNotifier {
  // The currently active/selected page in the dashboard's main content area.
  // Defaults to the 'overview' page when the service is initialized.
  DashboardPage _currentPage = DashboardPage.overview;

  /// Gets the current [DashboardPage] that should be displayed.
  DashboardPage get currentPage => _currentPage;

  /// Navigates to the specified [DashboardPage].
  ///
  /// This will update the [_currentPage] and notify listeners,
  /// causing the UI (e.g., DashboardLayout) to rebuild and display the new page.
  void navigateTo(DashboardPage page) {
    if (_currentPage != page) { // Only update and notify if the page actually changes
      _currentPage = page;
      notifyListeners();
    }
  }

  // --- Optional additions for more advanced state management related to sidebar ---

  // If you want to manage the expansion state of sidebar items more globally
  // (e.g., persist it across hot reloads or app sessions), you could add:
  //
  // Map<String, bool> _sidebarExpansionState = {}; // Key: item title/ID, Value: isExpanded
  //
  // bool isSidebarItemExpanded(String itemKey) {
  //   return _sidebarExpansionState[itemKey] ?? false;
  // }
  //
  // void toggleSidebarItemExpansion(String itemKey, {bool? isExpanded}) {
  //   if (isExpanded != null) {
  //     _sidebarExpansionState[itemKey] = isExpanded;
  //   } else {
  //     _sidebarExpansionState[itemKey] = !isSidebarItemExpanded(itemKey);
  //   }
  //   // You might want to notify listeners here if the sidebar itself rebuilds based on this service directly
  //   // For ExpansionTile's built-in state, this might not be strictly necessary
  //   // if the ExpansionTile handles its own state and you just use initiallyExpanded.
  //   // notifyListeners();
  // }
  //
  // // Example: For accordion style, where only one parent can be open.
  // String? _activeExpandedParentKey;
  // String? get activeExpandedParentKey => _activeExpandedParentKey;
  //
  // void setActiveExpandedParent(String? itemKey) {
  //   if (_activeExpandedParentKey != itemKey) {
  //     _activeExpandedParentKey = itemKey;
  //     notifyListeners(); // If sidebar structure depends on this for rebuilding
  //   }
  // }
}