// lib/widgets/dashboard/app_bar_actions.dart

import 'package:admin_dashboard_template/core/navigation/app_routes.dart';
import 'package:admin_dashboard_template/core/navigation/navigation_service.dart';
import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/providers/authentication_provider.dart'; // DIUBAH: Impor AuthenticationProvider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarActions extends StatelessWidget { // DIUBAH: Menjadi StatelessWidget
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final navigationService = context.read<NavigationService>();
    
    // Ambil data user dari provider. Bisa null jika belum login.
    final user = authProvider.user;

    return Row(
      children: [
        _NotificationBell(),
        const SizedBox(width: 16),
        PopupMenuButton<String>(
          tooltip: "Account",
          offset: const Offset(0, 40),
          onSelected: (value) async { // Jadikan async untuk logout
            if (value == 'profile') {
              navigationService.navigateTo(DashboardPage.profile);
            } else if (value == 'logout') {
              // DIUBAH: Panggil signOut dari authProvider
              await authProvider.signOut();
              // Navigasi akan di-handle oleh Consumer di app.dart,
              // namun untuk memastikan, kita bisa tambahkan navigasi manual.
              if (context.mounted) {
                 Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              }
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: AppColors.foreground),
                  const SizedBox(width: 8),
                  const Text('Profile'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: AppColors.error),
                  const SizedBox(width: 8),
                  Text('Logout', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
          child: CircleAvatar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            // DIUBAH: Tampilkan inisial nama atau email dari user model
            child: Text(
              user?.nama.isNotEmpty == true
                  ? user!.nama[0].toUpperCase()
                  : (user?.email.isNotEmpty == true ? user!.email[0].toUpperCase() : 'A'),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}

class _NotificationBell extends StatefulWidget {
  @override
  __NotificationBellState createState() => __NotificationBellState();
}

class __NotificationBellState extends State<_NotificationBell> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  final List<String> _notifications = [
    "New user registered: John Doe",
    "Order #12345 shipped",
    "Server maintenance scheduled for 2 AM",
    "Low stock alert: Product X",
  ];

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - 250 + size.width,
        top: offset.dy + size.height + 5,
        width: 300,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface, // Menggunakan warna dari AppColors
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Notifications", style: Theme.of(context).textTheme.titleLarge),
                ),
                const Divider(height:1),
                if (_notifications.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("No new notifications", style: Theme.of(context).textTheme.bodyMedium),
                  )
                else
                  LimitedBox(
                    maxHeight: 300,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_notifications[index], style: Theme.of(context).textTheme.bodyMedium),
                          leading: Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                          dense: true,
                          onTap: () {
                            _toggleDropdown();
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(onPressed: _toggleDropdown, child: const Text("Close")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          key: _key,
          icon: Icon(Icons.notifications_none_outlined, color: AppColors.foreground),
          tooltip: "Notifications",
          onPressed: _toggleDropdown,
        ),
        if (_notifications.isNotEmpty)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                _notifications.length.toString(),
                style: const TextStyle(
                  color: Colors.white, // Teks notifikasi tetap putih
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }
}