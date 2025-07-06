import 'package:admin_dashboard_template/core/navigation/navigation_service.dart';
import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/sidebar_menu_item.dart';
import 'package:admin_dashboard_template/widgets/dashboard/sidebar_clickable_item.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late final List<SidebarMenuItem> _menuItems;
  String? _currentlyExpandedParentKey;

  @override
  void initState() {
    super.initState();
    _menuItems = _buildMenuItems();
  }

  List<SidebarMenuItem> _buildMenuItems() {
    
    return [
      SidebarMenuItem(
        title: 'Overview',
        icon: Icons.dashboard_outlined,
        page: DashboardPage.overview,
      ),
      SidebarMenuItem(
        title: 'User Management',
        icon: Icons.people_alt_outlined,
        isExpanded: false,
        subItems: [
          SidebarMenuItem(
            title: 'Change Password',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.users,
          ),
          SidebarMenuItem(
            title: 'Settings',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.settings,
          ),
          SidebarMenuItem(
            title: 'User Admin Management',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.userAdminManagement,
          ),
        ],
      ),
      SidebarMenuItem(
        title: 'Kawan SS Management',
        icon: Icons.folder_shared_outlined,
        isExpanded: false,
        subItems: [
          SidebarMenuItem(
            title: 'Tema Siaran',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.kawanSSManagement,
          ),
          SidebarMenuItem(
            title: 'Banner Top',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.bannerTop,
          ),
          SidebarMenuItem(
            title: 'Pop Up',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.kawanSSManagement,
          ),
          SidebarMenuItem(
            title: 'Banner',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.kawanSSManagement,
          ),
          SidebarMenuItem(
            title: 'Kategori Kawan SS',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.kawanSSManagement,
          ),
          SidebarMenuItem(
            title: 'Kawan SS',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.kawanSS,
          ),
        ],
      ),
      SidebarMenuItem(
        title: 'Berita Web',
        icon: Icons.article_outlined,
        isExpanded: false,
        subItems: [
          SidebarMenuItem(
            title: 'Berita Web',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.beritaWeb,
          ),
          SidebarMenuItem(
            title: 'Potret Netter',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.beritaWeb,
          ),
          SidebarMenuItem(
            title: 'Video',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.beritaWeb,
          ),
          SidebarMenuItem(
            title: 'Potret Kelana Kota',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.beritaWeb,
          ),
          SidebarMenuItem(
            title: 'Podcast',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.beritaWeb,
          ),
        ],
      ),
      SidebarMenuItem(
        title: 'Kontributor',
        icon: Icons.folder_open_outlined,
        isExpanded: false,
        subItems: [
          SidebarMenuItem(
            title: 'Kontributor Management',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.kontributorManagement,
          ),
          SidebarMenuItem(
            title: 'Kontributor Post',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.kontributorPost,
          ),
          SidebarMenuItem(
            title: 'Kontributor Comment',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.kontributorComment,
          ),
          SidebarMenuItem(
            title: 'Postingan Terlapor',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.postinganTerlapor,
          ),
        ],
      ),
      SidebarMenuItem(
        title: 'Chat Management',
        icon: Icons.chat_bubble_outline,
        page: DashboardPage.chatManagement,
      ),
      SidebarMenuItem(
        title: 'Report Management',
        icon: Icons.flag_outlined,
        isExpanded: false,
        subItems: [
          SidebarMenuItem(
            title: 'Video Call',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.reportManagement,
          ),
          SidebarMenuItem(
            title: 'Audio Call',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.reportManagement,
          ),
          SidebarMenuItem(
            title: 'Registrasi Kontributor',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.reportManagement,
          ),
          SidebarMenuItem(
            title: 'Posting Kontributor',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.reportManagement,
          ),
          SidebarMenuItem(
            title: 'Posting Kawan SS',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.reportManagement,
          ),
          SidebarMenuItem(
            title: 'Like Posting',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.reportManagement,
          ),
          SidebarMenuItem(
            title: 'View Posting',
            icon: Icons.radio_button_unchecked_outlined,
            page: DashboardPage.reportManagement,
          ),
        ],
      ),
      SidebarMenuItem(
        title: 'Graph SNA',
        icon: Icons.offline_bolt,
        page: DashboardPage.socialnetworkanalysis,
      ),
      SidebarMenuItem(
        title: 'Products (Old)',
        icon: Icons.inventory_2_outlined,
        page: DashboardPage.products,
      ),
      SidebarMenuItem(
        title: 'Calendar (Old)',
        icon: Icons.calendar_today_outlined,
        page: DashboardPage.calendar,
      ),
      SidebarMenuItem(
        title: 'Charts (Old)',
        icon: Icons.bar_chart_outlined,
        page: DashboardPage.charts,
      ),
      SidebarMenuItem(
        title: 'Forms (Old)',
        icon: Icons.edit_note_outlined,
        page: DashboardPage.forms,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationService>(context);
    final currentPage = navigationService.currentPage;

    bool isAnySubItemSelected(SidebarMenuItem parentItem) {
      if (parentItem.subItems == null) return false;
      return parentItem.subItems!.any((subItem) => subItem.page == currentPage);
    }

    return Container(
      width: 260,
      color: AppColors.surface, 
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Admin Panel',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                bool isParentOfSelectedChild = isAnySubItemSelected(item);
                bool isDirectlySelected = item.page == currentPage;
                bool isParentEffectivelyActive =
                    item.isExpanded || isParentOfSelectedChild;
                if (item.subItems != null && item.subItems!.isNotEmpty) {
                  return Container(
                    
                    decoration: BoxDecoration(
                      color:
                          isParentEffectivelyActive
                              ? AppColors.primary
                              : AppColors.surface,
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: const Color.fromRGBO(0, 0, 0, 0),
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 16.0,
                        ),

                        key: PageStorageKey<String>(item.title),
                        iconColor: AppColors.surface,
                        collapsedIconColor:
                            isParentOfSelectedChild
                                ? AppColors.surface
                                : AppColors.foreground,
                        initiallyExpanded:
                            item.isExpanded || isParentOfSelectedChild,
                        onExpansionChanged: (bool expanding) {
                          setState(() {
                            if (expanding) {
                              for (var menuItem in _menuItems) {
                                if (menuItem.title != item.title &&
                                    menuItem.subItems != null) {
                                  menuItem.isExpanded = false;
                                }
                              }
                              item.isExpanded = true;
                              _currentlyExpandedParentKey = item.title;
                            } else {
                              item.isExpanded = false;
                              if (_currentlyExpandedParentKey == item.title) {
                                _currentlyExpandedParentKey = null;
                              }
                            }
                          });
                        },
                        leading: Icon(
                          item.icon,
                          color:
                              isParentEffectivelyActive
                                  ? AppColors.surface
                                  : AppColors.foreground,
                          size: 20,
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color:
                                isParentEffectivelyActive
                                    ? AppColors.surface
                                    : AppColors.foreground,
                            fontWeight:
                                isParentEffectivelyActive
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        children:
                            item.subItems!
                                .map(
                                  (subItem) => SidebarClickableItem(
                                    
                                    icon: subItem.icon,
                                    title: subItem.title,
                                    isSelected: subItem.page == currentPage,
                                    onTap: () {
                                      if (subItem.page != null) {
                                        navigationService.navigateTo(
                                          subItem.page!,
                                        );
                                      }
                                    },
                                    level: 1,
                                    sidebarBackgroundColor: AppColors.surface,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  );
                } else {
                  return SidebarClickableItem(
                    
                    icon: item.icon,
                    title: item.title,
                    isSelected: isDirectlySelected,
                    onTap: () {
                      if (item.page != null) {
                        navigationService.navigateTo(item.page!);
                      }
                    },
                    level: 0,
                    sidebarBackgroundColor: AppColors.surface,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
