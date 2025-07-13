import 'package:admin_dashboard_template/core/auth/auth_service.dart';
import 'package:admin_dashboard_template/core/navigation/app_routes.dart';
import 'package:admin_dashboard_template/core/navigation/navigation_service.dart';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/core/theme/app_theme.dart';
import 'package:admin_dashboard_template/providers/auth/authentication_provider.dart';
import 'package:admin_dashboard_template/providers/banner_provider.dart';
import 'package:admin_dashboard_template/providers/chat_provider.dart';
import 'package:admin_dashboard_template/providers/infoss_provider.dart';
import 'package:admin_dashboard_template/providers/kategori_provider.dart';
import 'package:admin_dashboard_template/providers/kawanss_post_provider.dart';
import 'package:admin_dashboard_template/providers/kawanss_provider.dart';
import 'package:admin_dashboard_template/providers/kontributor_provider.dart';
import 'package:admin_dashboard_template/providers/news_provider.dart';
import 'package:admin_dashboard_template/providers/settings_provider.dart';
import 'package:admin_dashboard_template/providers/user_provider.dart';
import 'package:admin_dashboard_template/screens/auth/login_screen.dart';
import 'package:admin_dashboard_template/screens/auth/register_screen.dart';
import 'package:admin_dashboard_template/screens/dashboard/dashboard_layout.dart';
import 'package:admin_dashboard_template/screens/dashboard/report/report_provider.dart';
import 'package:admin_dashboard_template/screens/unknown_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),

        ChangeNotifierProvider<NavigationService>(
          create: (_) => NavigationService(),
        ),

        ChangeNotifierProvider<AuthenticationProvider>(
          create:
              (context) => AuthenticationProvider(
                authService: context.read<AuthService>(),
                firestoreService: context.read<FirestoreService>(),
              ),
        ),

        ChangeNotifierProvider<UserProvider>(
          create:
              (context) => UserProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        ChangeNotifierProvider<KawanssProvider>(
          create:
              (context) => KawanssProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        // --- TAMBAHKAN PROVIDER BARU DI SINI ---
        ChangeNotifierProvider<KawanssPostProvider>(
          create:
              (context) => KawanssPostProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        ChangeNotifierProvider<InfossProvider>(
          create:
              (context) => InfossProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        ChangeNotifierProvider<KontributorProvider>(
          create:
              (context) => KontributorProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        ChangeNotifierProvider<NewsProvider>(
          create:
              (context) => NewsProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        ChangeNotifierProvider<BannerProvider>(
          create:
              (context) => BannerProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create:
              (context) => SettingsProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create:
              (context) => ChatProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create:
              (context) => ChatProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        // TAMBAHKAN PROVIDER BARU DI SINI
        ChangeNotifierProvider<ReportProvider>(
          create:
              (context) => ReportProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
        ChangeNotifierProvider<KategoriProvider>(
          create:
              (context) => KategoriProvider(
                firestoreService: context.read<FirestoreService>(),
              ),
        ),
      ],

      builder: (context, child) {
        final authStatus = context.select(
          (AuthenticationProvider p) => p.status,
        );

        return MaterialApp(
          title: 'Admin Dashboard',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,

          home: _buildHome(authStatus),

          routes: {
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const RegisterScreen(),
          },
          onUnknownRoute:
              (settings) =>
                  MaterialPageRoute(builder: (_) => const UnknownScreen()),
        );
      },
    );
  }

  Widget _buildHome(AuthStatus status) {
    switch (status) {
      case AuthStatus.Authenticated:
        return const DashboardLayout();
      case AuthStatus.Unauthenticated:
        return const LoginScreen();
      case AuthStatus.Uninitialized:
      case AuthStatus.Authenticating:
      default:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
