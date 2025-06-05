import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard_template/core/theme/app_colors.dart'; // For chart colors

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      key: const PageStorageKey('overviewPage'), // Preserve scroll position
      children: [
        Text('Dashboard Overview', style: textTheme.headlineMedium),
        const SizedBox(height: 20),
        Wrap( // Use Wrap for responsiveness of stat cards
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildStatCard(context, Icons.people_alt_outlined, 'Total Users', '1,250', AppColors.primary),
            _buildStatCard(context, Icons.shopping_cart_outlined, 'Total Orders', '3,480', AppColors.secondary),
            _buildStatCard(context, Icons.attach_money_outlined, 'Total Revenue', '\$75,930', Colors.green.shade600),
            _buildStatCard(context, Icons.new_releases_outlined, 'New Signups', '85', Colors.orange.shade600),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sales Over Time', style: textTheme.titleLarge),
                    const SizedBox(height: 20),
                    SizedBox(height: 300, child: _buildLineChart()),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Activity', style: textTheme.titleLarge),
                    const SizedBox(height: 10),
                    _buildActivityItem(Icons.person_add_alt_1_outlined, 'New user "Jane Doe" registered.', '5 min ago'),
                    const Divider(),
                    _buildActivityItem(Icons.receipt_long_outlined, 'Order #INV005 completed.', '30 min ago'),
                    const Divider(),
                    _buildActivityItem(Icons.production_quantity_limits_outlined, 'Product "Flutter Pro" updated.', '1 hr ago'),
                     const Divider(),
                    _buildActivityItem(Icons.comment_outlined, 'New comment on "Blog Post X".', '2 hrs ago'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        // Add more widgets like recent orders table, etc.
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String title, String value, Color iconColor) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox( // Ensure cards have a min width for better wrap layout
        constraints: const BoxConstraints(minWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.darkGrey)),
                Icon(icon, color: iconColor, size: 28),
              ],
            ),
            const SizedBox(height: 10),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: true, getDrawingHorizontalLine: (value) => FlLine(color: AppColors.lightGrey.withOpacity(0.5), strokeWidth: 0.5),getDrawingVerticalLine: (value) => FlLine(color: AppColors.lightGrey.withOpacity(0.5), strokeWidth: 0.5)),
        titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1, getTitlesWidget: bottomTitleWidgets)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 100, getTitlesWidget: leftTitleWidgets)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: AppColors.lightGrey.withOpacity(0.5), width: 1)),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 600, // Adjusted MaxY
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 300), FlSpot(1, 450), FlSpot(2, 320), FlSpot(3, 500),
              FlSpot(4, 380), FlSpot(5, 420), FlSpot(6, 550),
            ],
            isCurved: true,
            color: AppColors.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: AppColors.primary.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.bold, fontSize: 12,);
    Widget text;
    switch (value.toInt()) {
      case 0: text = const Text('Jan', style: style); break;
      case 1: text = const Text('Feb', style: style); break;
      case 2: text = const Text('Mar', style: style); break;
      case 3: text = const Text('Apr', style: style); break;
      case 4: text = const Text('May', style: style); break;
      case 5: text = const Text('Jun', style: style); break;
      case 6: text = const Text('Jul', style: style); break;
      default: text = const Text('', style: style); break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.bold, fontSize: 12);
    String text;
    if (value.toInt() % 100 == 0) { // Show labels for every 100
      text = '\$${value.toInt()}';
    } else {
      return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget _buildActivityItem(IconData icon, String text, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: AppColors.onSurface))),
          Text(time, style: TextStyle(fontSize: 12, color: AppColors.darkGrey)),
        ],
      ),
    );
  }
}