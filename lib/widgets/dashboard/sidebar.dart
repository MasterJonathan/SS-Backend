import 'package:admin_dashboard_template/core/navigation/navigation_service.dart';
import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationService>(context);
    final currentPath = navigationService.currentPage;

    return Container(
      width: 250,
      color: AppColors.sidebarBackground,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.dashboard_customize, color: AppColors.primary, size: 30),
                const SizedBox(width: 10),
                Text(
                  'Admin Panel',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          _SidebarItem(
            icon: Icons.dashboard_outlined,
            title: 'Overview',
            page: DashboardPage.overview,
            isSelected: currentPath == DashboardPage.overview,
            onTap: () => navigationService.navigateTo(DashboardPage.overview),
          ),
          _SidebarItem(
            icon: Icons.people_alt_outlined,
            title: 'Users',
            page: DashboardPage.users,
            isSelected: currentPath == DashboardPage.users,
            onTap: () => navigationService.navigateTo(DashboardPage.users),
          ),
          _SidebarItem(
            icon: Icons.inventory_2_outlined,
            title: 'Products',
            page: DashboardPage.products,
            isSelected: currentPath == DashboardPage.products,
            onTap: () => navigationService.navigateTo(DashboardPage.products),
          ),
          _SidebarItem(
            icon: Icons.calendar_today_outlined,
            title: 'Calendar',
            page: DashboardPage.calendar,
            isSelected: currentPath == DashboardPage.calendar,
            onTap: () => navigationService.navigateTo(DashboardPage.calendar),
          ),
          _SidebarItem(
            icon: Icons.bar_chart_outlined,
            title: 'Charts',
            page: DashboardPage.charts,
            isSelected: currentPath == DashboardPage.charts,
            onTap: () => navigationService.navigateTo(DashboardPage.charts),
          ),
          _SidebarItem(
            icon: Icons.edit_note_outlined,
            title: 'Forms',
            page: DashboardPage.forms,
            isSelected: currentPath == DashboardPage.forms,
            onTap: () => navigationService.navigateTo(DashboardPage.forms),
          ),
          _SidebarItem(
            icon: Icons.offline_bolt, 
            title: 'Graph SNA', 
            page: DashboardPage.socialnetworkanalysis, 
            isSelected: currentPath == DashboardPage.socialnetworkanalysis, 
            onTap: () => navigationService.navigateTo(DashboardPage.socialnetworkanalysis)),
          const Spacer(), // Pushes settings and profile to the bottom
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8.0),
             child: const Divider(color: Colors.white24, height: 1),
           ),
          _SidebarItem(
            icon: Icons.person_outline,
            title: 'Profile',
            page: DashboardPage.profile,
            isSelected: currentPath == DashboardPage.profile,
            onTap: () => navigationService.navigateTo(DashboardPage.profile),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final DashboardPage page;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected
        ? AppColors.sidebarSelectedText
        : AppColors.sidebarText;
    final bgColor = widget.isSelected
        ? AppColors.sidebarSelected
        : _isHovered
            ? AppColors.sidebarHover
            : AppColors.sidebarBackground;

    return Material(
      color: bgColor,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) {
          setState(() {
            _isHovered = hovering;
          });
        },
        splashColor: AppColors.primary.withOpacity(0.3),
        hoverColor: AppColors.sidebarHover,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Icon(widget.icon, color: color),
              const SizedBox(width: 15),
              Text(
                widget.title,
                style: TextStyle(
                  color: color,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}