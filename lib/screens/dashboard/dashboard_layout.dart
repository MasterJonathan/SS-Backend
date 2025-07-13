import 'package:admin_dashboard_template/screens/dashboard/berita/berita_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/chat_management_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/infoss_management/banner_top_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/infoss_management/infoss_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/kategori_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/kawanss/kawanss_management_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/kawanss/kawanss_post_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/report/report_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/template/calendar_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/template/charts_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/template/forms_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/overview_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/template/products_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/profile_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/user_management/settings_page.dart';
import 'package:admin_dashboard_template/screens/dashboard/user_management/users_page.dart';
import 'package:admin_dashboard_template/widgets/dashboard/app_bar_actions.dart';
import 'package:admin_dashboard_template/widgets/dashboard/sidebar.dart';
import 'package:admin_dashboard_template/core/navigation/navigation_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key});

  Widget _getPage(DashboardPage page) {
    switch (page) {
      case DashboardPage.overview:
        return const OverviewPage();

      case DashboardPage.report:
        return const ReportPage();

      case DashboardPage.settings:
        return const SettingsPage();
      case DashboardPage.userAdminManagement:
        return const UsersAdminPage();

      case DashboardPage.bannerTop:
        return const BannerTopPage();
      case DashboardPage.infoSS:
        return const InfossPage();

      case DashboardPage.berita:
        return const BeritaPage();
      case DashboardPage.kawanssManagement:
        return const KawanssManagementPage();
      case DashboardPage.kawanssPost:
        return const KawanssPostPage();
      case DashboardPage.chatManagement:
        return const ChatManagementPage();

      case DashboardPage.kategoriss:
        return const KategoriPage();

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
      // Halaman-halaman baru berdasarkan daftar Anda
      case DashboardPage.overview:
        return 'Overview';
      case DashboardPage.report:
        return 'Report Management';
      case DashboardPage.settings:
        return 'Website Settings';
      case DashboardPage.userAdminManagement:
        return 'User Admin Management'; // Atau 'User Management' jika sama
      case DashboardPage.bannerTop:
        return 'Banner Top Management';
      case DashboardPage.infoSS:
        return 'Info SS Management';
      case DashboardPage.berita:
        return 'Berita Web Management';
      case DashboardPage.kawanssManagement:
        return 'Kawan SS Management';
      case DashboardPage.kawanssPost:
        return 'Post Kawan SS'; // Atau 'Kontributor Post' jika itu halamannya
      case DashboardPage.chatManagement:
        return 'Chat Management';
      case DashboardPage.kategoriss:
        return 'Kategori Management';

      // Halaman-halaman lama dari contoh awal
      case DashboardPage
          .users: // Jika 'users' dan 'userAdminManagement' berbeda
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

      // Default jika ada case yang terlewat
      default:
        return 'Dashboard';
    }
  }
}
