import 'package:admin_dashboard_template/core/auth/auth_service.dart';
import 'package:admin_dashboard_template/core/navigation/app_routes.dart';
import 'package:admin_dashboard_template/core/navigation/navigation_service.dart';
import 'package:admin_dashboard_template/core/theme/app_theme.dart';
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
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => NavigationService()),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, child) {
          return MaterialApp(
            title: 'Flutter Admin Dashboard',
            theme: AppTheme.lightTheme,
            // darkTheme: AppTheme.darkTheme, // Optional
            // themeMode: ThemeMode.system, // Or manage with a ThemeService
            debugShowCheckedModeBanner: false,
            initialRoute: authService.isAuthenticated ? AppRoutes.dashboard : AppRoutes.login,
            onGenerateRoute: (settings) {
              // This allows for dynamic routing and passing arguments if needed
              // For this example, it's simple.
              Widget page;
              bool needsAuth = true;

              switch (settings.name) {
                case AppRoutes.login:
                  page = const LoginScreen();
                  needsAuth = false;
                  break;
                case AppRoutes.register:
                  page = const RegisterScreen(); // Make sure to create this screen
                  needsAuth = false;
                  break;
                case AppRoutes.dashboard:
                  page = const DashboardLayout();
                  break;
                default:
                  page = const UnknownScreen();
                  needsAuth = false; // Or true, depending on your logic for unknown routes
              }

              if (needsAuth && !authService.isAuthenticated) {
                // Redirect to login if trying to access an authenticated route without being logged in
                return MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                  settings: const RouteSettings(name: AppRoutes.login) // To avoid loops
                );
              }

              return MaterialPageRoute(
                builder: (_) => page,
                settings: settings, // Pass along the route settings
              );
            },
            onUnknownRoute: (settings) {
              // Fallback for routes not defined in onGenerateRoute
              return MaterialPageRoute(builder: (_) => const UnknownScreen());
            },
          );
        },
      ),
    );
  }
}