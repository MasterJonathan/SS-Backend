import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/activity_model.dart';
import 'package:flutter/material.dart';

class ActivityFeedPanel extends StatefulWidget {
  final bool isExternallyScrolled;

  const ActivityFeedPanel({
    super.key,
    this.isExternallyScrolled = false,
  });

  @override
  State<ActivityFeedPanel> createState() => _ActivityFeedPanelState();
}

class _ActivityFeedPanelState extends State<ActivityFeedPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ActivityModel> _activities = [
    ActivityModel(icon: Icons.message, iconColor: Colors.green, description: 'Membuka postingan 10.24: Menganti Gresik Macet...', timeAgo: '01 bulan yang lalu'),
    ActivityModel(icon: Icons.message, iconColor: Colors.green, description: 'Membuka postingan 07.37: Tambak Mayor dan Simpang Kenjeran Macet', timeAgo: '02 bulan yang lalu'),
    ActivityModel(icon: Icons.message, iconColor: Colors.green, description: 'Membuka postingan 09.17: Kecelakaan Dua Motor di Ngagel Jaya', timeAgo: '02 bulan yang lalu'),
    ActivityModel(icon: Icons.thumb_up, iconColor: Colors.blue, description: 'Menyukai postingan 10.31: Simpang Lakarsantri Macet', timeAgo: '02 bulan yang lalu'),
    ActivityModel(icon: Icons.message, iconColor: Colors.green, description: 'Membuka postingan 15.57: Sejumlah pendengar Radio Suara Surabaya...', timeAgo: '02 bulan yang lalu'),
    ActivityModel(icon: Icons.message, iconColor: Colors.green, description: 'Membuka postingan 10.24: Menganti Gresik Macet...', timeAgo: '03 bulan yang lalu'),
    ActivityModel(icon: Icons.message, iconColor: Colors.green, description: 'Membuka postingan 07.37: Tambak Mayor dan Simpang Kenjeran Macet', timeAgo: '03 bulan yang lalu'),
    ActivityModel(icon: Icons.thumb_up, iconColor: Colors.blue, description: 'Menyukai postingan 09.17: Kecelakaan Dua Motor di Ngagel Jaya', timeAgo: '03 bulan yang lalu'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.removeListener(() => setState(() {}));
    _tabController.dispose();
    super.dispose();
  }

  
  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      
      labelColor: AppColors.surface,
      unselectedLabelColor: AppColors.primary,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),

      
      dividerColor: Colors.transparent,
      
      
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        
        color: Theme.of(context).primaryColor,
        
        borderRadius: BorderRadius.circular(4.0),
      ),
      tabs: const [
        Tab(text: 'Posting'),
        Tab(text: 'Aktivitas'),
        Tab(text: 'Video/Audio Call'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: widget.isExternallyScrolled
          ? _buildShrinkWrappedLayout()
          : _buildExpandedLayout(),
    );
  }

  Widget _buildExpandedLayout() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildTabBar(), 
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _activities.length,
                itemBuilder: (context, index) => _buildActivityTile(_activities[index]),
              ),
              const Center(child: Text('Aktivitas Belum Tersedia')),
              const Center(child: Text('Video/Audio Call Belum Tersedia')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShrinkWrappedLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildTabBar(), 
        ),
        IndexedStack(
          index: _tabController.index,
          children: [
            Visibility(
              visible: _tabController.index == 0,
              maintainState: true,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _activities.length,
                itemBuilder: (context, index) => _buildActivityTile(_activities[index]),
              ),
            ),
            const Padding( padding: EdgeInsets.all(32.0), child: Center(child: Text('Aktivitas Belum Tersedia'))),
            const Padding( padding: EdgeInsets.all(32.0), child: Center(child: Text('Video/Audio Call Belum Tersedia'))),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityTile(ActivityModel activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar( backgroundColor: activity.iconColor.withOpacity(0.1), child: Icon(activity.icon, color: activity.iconColor, size: 20)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.description),
                const SizedBox(height: 4),
                Text( activity.timeAgo, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}