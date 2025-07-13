import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/infoss_model.dart';
import 'package:admin_dashboard_template/screens/dashboard/report/report_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();
    final textTheme = Theme.of(context).textTheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView(
        key: const PageStorageKey('reportPage'),
        padding: const EdgeInsets.all(0),
        children: [
          _buildHeader(textTheme),
          const SizedBox(height: 32),
          _buildStatsGrid(reportProvider),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildTopPosts(textTheme, reportProvider),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: _buildAnalyticsCard(textTheme, reportProvider),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildTrafficChartCard(textTheme, reportProvider),
          const SizedBox(height: 32),
          _buildSheetDataTable(textTheme, reportProvider), // Menampilkan data Google Sheets
        ],
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.analytics_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Laporan & Analitik',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pantau performa dan statistik platform Anda',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ReportProvider provider) {
    if (provider.isStatsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.statsErrorMessage != null) {
      return Center(child: Text(provider.statsErrorMessage!));
    }

    final stats = provider.monthlyStats ??
        {'totalUsers': 0, 'newUsers': 0, 'newUsersChange': 0.0, 'totalPosts': 0, 'newPosts': 0};
    final numberFormat = NumberFormat.decimalPattern('id_ID');
    final double newUsersChange = (stats['newUsersChange'] as num).toDouble();

    final statsData = [
      {'icon': Icons.people_alt_rounded, 'title': 'Total Pengguna', 'value': numberFormat.format(stats['totalUsers']), 'change': null},
      {'icon': Icons.person_add_rounded, 'title': 'Pendaftar Baru (30 Hari)', 'value': numberFormat.format(stats['newUsers']), 'change': newUsersChange},
      {'icon': Icons.article_rounded, 'title': 'Total Postingan', 'value': numberFormat.format(stats['totalPosts']), 'change': null},
      {'icon': Icons.new_releases_rounded, 'title': 'Postingan Baru (30 Hari)', 'value': numberFormat.format(stats['newPosts']), 'change': null},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.4,
      ),
      itemCount: statsData.length,
      itemBuilder: (context, index) {
        final data = statsData[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 800 + (index * 200)),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildEnhancedStatCard(
                icon: data['icon'] as IconData,
                title: data['title'] as String,
                value: data['value'] as String,
                change: data['change'] as double?,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEnhancedStatCard({required IconData icon, required String title, required String value, double? change}) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              if(change != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: change >= 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        change >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: change >= 0 ? Colors.green.shade600 : Colors.red.shade600,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${change.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: change >= 0 ? Colors.green.shade600 : Colors.red.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPosts(TextTheme textTheme, ReportProvider provider) {
    if (provider.isStatsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '10 Postingan Info SS Terpopuler',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  Colors.grey.shade50,
                ),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                dataRowMaxHeight: 60,
                columns: const [
                  DataColumn(label: Text('Ranking')),
                  DataColumn(label: Text('Judul Postingan')),
                  DataColumn(label: Text('Views'), numeric: true),
                ],
                rows: provider.topPosts.asMap().entries.map((entry) {
                  int index = entry.key;
                  InfossModel post = entry.value;
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return AppColors.primary.withOpacity(0.05);
                        }
                        return null;
                      },
                    ),
                    cells: [
                      DataCell(
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getRankColor(index),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 300,
                          child: Text(
                            post.judul,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            NumberFormat.decimalPattern('id_ID')
                                .format(post.jumlahView),
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
     switch (index) {
      case 0: return const Color(0xFFFFD700); // Gold
      case 1: return const Color(0xFFC0C0C0); // Silver
      case 2: return const Color(0xFFCD7F32); // Bronze
      default: return Colors.grey.shade600;
    }
  }

  Widget _buildAnalyticsCard(TextTheme textTheme, ReportProvider provider) {
    void _launchURL(String url) async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak bisa membuka $url')),
        );
      }
    }
  
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.integration_instructions_rounded,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Integrasi & Ekspor',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            icon: Icons.table_chart_outlined,
            label: 'Buka Google Sheets',
            colors: [const Color(0xFF188038), const Color(0xFF10B981)],
            onPressed: () {
              const sheetUrl = 'https://docs.google.com/spreadsheets/d/1F2obOikLOn92ewLwLlPhmVdhAW19EO15CcOZG_rtOWc';
              _launchURL(sheetUrl);
              FirebaseAnalytics.instance.logEvent(name: 'open_google_sheets', parameters: {'url': sheetUrl});
            },
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.analytics_outlined,
            label: 'Buka Google Analytics',
            colors: [const Color(0xFFF4B400), const Color(0xFFFF9800)],
            onPressed: () {
              const analyticsUrl = 'https://analytics.google.com/';
              _launchURL(analyticsUrl);
              FirebaseAnalytics.instance.logEvent(name: 'open_google_analytics', parameters: {'url': analyticsUrl});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required List<Color> colors, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficChartCard(TextTheme textTheme, ReportProvider provider) {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    provider.trafficChartTitle,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _buildTimeRangeChips(provider),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 320,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: provider.isTrafficLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.trafficData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Tidak ada data traffic untuk rentang ini.",
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildBarChart(provider),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeChips(ReportProvider provider) {
    return Wrap(
      spacing: 8.0,
      children: TrafficTimeRange.values.map((range) {
        final isSelected = provider.selectedTimeRange == range;
        return FilterChip(
          label: Text(
            toBeginningOfSentenceCase(range.name.toLowerCase()) ?? '',
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: isSelected,
          onSelected: provider.isTrafficLoading
              ? null
              : (bool selected) {
                  if (selected) {
                    provider.fetchTrafficReport(range);
                  }
                },
          backgroundColor: isSelected
              ? AppColors.primary
              : Colors.grey.shade200,
          selectedColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBarChart(ReportProvider provider) {
     double maxY = 0;
    if (provider.trafficData.isNotEmpty) {
      maxY = provider.trafficData.reduce((a, b) => a > b ? a : b) * 1.2;
    }
    if (maxY < 5) maxY = 5;

    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()} views',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= provider.trafficLabels.length) {
                  return const Text('');
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    provider.trafficLabels[index],
                    style: TextStyle(
                      color: AppColors.foreground.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
              reservedSize: 28,
              interval: provider.selectedTimeRange == TrafficTimeRange.Bulanan
                  ? 3
                  : 1,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: provider.trafficData.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                width: 20,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Widget baru untuk menampilkan data Google Sheets
  Widget _buildSheetDataTable(TextTheme textTheme, ReportProvider provider) {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data dari Google Sheets',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: provider.isSheetDataLoading ? null : () => provider.fetchSheetData(),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Tarik Data'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16)),
              )
            ],
          ),
          const SizedBox(height: 24),
          if (provider.isSheetDataLoading)
            const Center(child: CircularProgressIndicator())
          else if (provider.sheetDataErrorMessage != null)
            Center(child: Text(provider.sheetDataErrorMessage!, style: TextStyle(color: AppColors.error)))
          else if (provider.sheetData.isEmpty)
            const Center(child: Text('Tidak ada data. Klik tombol "Tarik Data" untuk memuat.'))
          else
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: provider.sheetData.first.keys.map((key) => DataColumn(label: Text(key.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
                  rows: provider.sheetData.map((row) {
                    return DataRow(
                      cells: row.values.map((cell) => DataCell(Text(cell))).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}