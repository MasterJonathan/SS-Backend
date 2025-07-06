// lib/app.dart

import 'package:admin_dashboard_template/core/auth/auth_service.dart';
import 'package:admin_dashboard_template/core/navigation/app_routes.dart';
import 'package:admin_dashboard_template/core/navigation/navigation_service.dart';
import 'package:admin_dashboard_template/core/services/firestore_service.dart';
import 'package:admin_dashboard_template/core/theme/app_theme.dart';
import 'package:admin_dashboard_template/providers/authentication_provider.dart';
import 'package:admin_dashboard_template/providers/banner_provider.dart';
import 'package:admin_dashboard_template/providers/chat_provider.dart';
import 'package:admin_dashboard_template/providers/kawanss_provider.dart';
import 'package:admin_dashboard_template/providers/kontributor_provider.dart';
import 'package:admin_dashboard_template/providers/news_provider.dart';
import 'package:admin_dashboard_template/providers/settings_provider.dart';
import 'package:admin_dashboard_template/providers/user_provider.dart';
import 'package:admin_dashboard_template/screens/auth/login_screen.dart';
import 'package:admin_dashboard_template/screens/auth/register_screen.dart';
import 'package:admin_dashboard_template/screens/dashboard/dashboard_layout.dart';
import 'package:admin_dashboard_template/screens/unknown_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Daftarkan Service (Class biasa, tanpa state UI)
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),

        // 2. Daftarkan Provider (ChangeNotifier untuk state management)
        
        ChangeNotifierProvider<NavigationService>(
          create: (_) => NavigationService(),
        ),

        ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) => AuthenticationProvider(
            authService: context.read<AuthService>(),
            firestoreService: context.read<FirestoreService>(),
          ),
        ),

        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(
            firestoreService: context.read<FirestoreService>(),
          ),
        ),
        ChangeNotifierProvider<KawanssProvider>(
          create: (context) => KawanssProvider(
            firestoreService: context.read<FirestoreService>(),
          ),
        ),
        ChangeNotifierProvider<KontributorProvider>(
          create: (context) => KontributorProvider(
            firestoreService: context.read<FirestoreService>(),
          ),
        ),
        ChangeNotifierProvider<NewsProvider>(
          create: (context) => NewsProvider(
            firestoreService: context.read<FirestoreService>(),
          ),
        ),
        ChangeNotifierProvider<BannerProvider>(
          create: (context) => BannerProvider(
            firestoreService: context.read<FirestoreService>(),
          ),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (context) => SettingsProvider(
            firestoreService: context.read<FirestoreService>(),
          ),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(
            firestoreService: context.read<FirestoreService>(),
          ),
        ),
      ],
      // Gunakan 'builder' untuk merekonstruksi MaterialApp berdasarkan state
      builder: (context, child) {
        // Gunakan 'select' agar hanya rebuild saat 'status' berubah, lebih efisien
        final authStatus = context.select((AuthenticationProvider p) => p.status);
        
        return MaterialApp(
          title: 'Admin Dashboard',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          // Gunakan 'home' untuk menentukan halaman awal secara dinamis.
          // Ini lebih aman daripada 'initialRoute' saat startup.
          home: _buildHome(authStatus),
          
          // 'routes' tetap berguna untuk navigasi bernama seperti Navigator.pushNamed()
          routes: {
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const RegisterScreen(),
          },
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (_) => const UnknownScreen(),
          ),
        );
      },
    );
  }

  // Helper widget untuk memilih halaman awal berdasarkan status otentikasi
  Widget _buildHome(AuthStatus status) {
    switch (status) {
      case AuthStatus.Authenticated:
        return const DashboardLayout();
      case AuthStatus.Unauthenticated:
        return const LoginScreen();
      case AuthStatus.Uninitialized:
      case AuthStatus.Authenticating:
      default:
        // Tampilkan layar loading saat status belum pasti atau sedang proses
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}