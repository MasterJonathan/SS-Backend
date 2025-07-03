import 'package:admin_dashboard_template/screens/dashboard/beritaweb/berita_web_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/chat_management_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/kawanss_management/banner_top_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/kawanss_management/kawanss_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/kontributor/kontributor_management_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/kontributor/kontributor_post_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/template/calendar_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/template/charts_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/contributor_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/template/forms_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/overview_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/template/products_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/profile_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/user_management/settings_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/user_management/users_admin_management_page.dart';
import 'package:admin_dashboard_template/widgets/dashboard/app_bar_actions.dart';
import 'package:admin_dashboard_template/widgets/dashboard/sidebar.dart';
import 'package:admin_dashboard_template/core/navigation/navigation_service.dart';
import 'package:admin_dashboard_template/screens/dashboard/socialnetworkanalysis.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key});

  Widget _getPage(DashboardPage page) {
    switch (page) {

      case DashboardPage.overview:
        return const OverviewPage();

      case DashboardPage.settings:
        return const SettingsPage();
      case DashboardPage.userAdminManagement:
        return const UsersAdminPage();

      case DashboardPage.bannerTop:
        return const BannerTopPage();
      case DashboardPage.kawanSS:
        return const KawanssPage();
      
      case DashboardPage.beritaWeb:
        return const BeritaWebPage();
      case DashboardPage.kontributorManagement:
        return const KontributorManagementPage();
      case DashboardPage.kontributorPost:
        return const KontributorPostPage();
      case DashboardPage.chatManagement:
        return const ChatManagementPage();





      case DashboardPage.products:
        return const ProductsPage();
      case DashboardPage.calendar:
        return const CalendarAdminPage();
      case DashboardPage.charts:
        return const ChartsPage();
      case DashboardPage.forms:
        return const FormsDemoPage();
      case DashboardPage.profile:
        return const ProfilePage();
      case DashboardPage.contributor:
        return const ContributorPage();
      case DashboardPage.socialnetworkanalysis:
        return const Socialnetworkanalysis();
      default:
        return const OverviewPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationService>(context);

    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(_getPageTitle(navigationService.currentPage)),
                  actions: const [AppBarActions()],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _getPage(navigationService.currentPage),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(DashboardPage page) {
    switch (page) {
      case DashboardPage.overview:
        return 'Overview';
      case DashboardPage.users:
        return 'User Management';
      case DashboardPage.products:
        return 'Product Management';
      case DashboardPage.calendar:
        return 'Calendar';
      case DashboardPage.charts:
        return 'Data Charts';
      case DashboardPage.forms:
        return 'Form Elements';
      case DashboardPage.profile:
        return 'User Profile';
      case DashboardPage.contributor:
        return 'Contributor';
      default:
        return 'Dashboard';
    }
  }
}
