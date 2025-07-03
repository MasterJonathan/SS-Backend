import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView( // Using ListView to allow multiple charts
      key: const PageStorageKey('chartsPage'),
      padding: const EdgeInsets.all(0), // CustomCard will handle padding
      children: [
        Text('Data Visualizations', style: textTheme.headlineMedium),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Traffic Sources (Pie Chart)', style: textTheme.titleLarge),
                    const SizedBox(height: 20),
                    SizedBox(height: 300, child: _buildPieChart()),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Registrations (Bar Chart)', style: textTheme.titleLarge),
                    const SizedBox(height: 20),
                    SizedBox(height: 300, child: _buildBarChart()),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // You can add more charts here
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(color: AppColors.primary, value: 40, title: 'Organic', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          PieChartSectionData(color: Colors.blue, value: 30, title: 'Referral', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
          PieChartSectionData(color: Colors.orange, value: 15, title: 'Direct', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          PieChartSectionData(color: Colors.red, value: 15, title: 'Social', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
            const style = TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11);
            String text;
            switch (value.toInt()) {
              case 0: text = 'Jan'; break;
              case 1: text = 'Feb'; break;
              case 2: text = 'Mar'; break;
              case 3: text = 'Apr'; break;
              case 4: text = 'May'; break;
              default: text = ''; break;
            }
            return SideTitleWidget(axisSide: meta.axisSide, space: 4, child: Text(text, style: style));
          }, reservedSize: 28)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 5)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: AppColors.primary.withAlpha(120), strokeWidth: 0.5),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: AppColors.primary.withAlpha(120))),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: AppColors.primary, width: 15)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: AppColors.primary, width: 15)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: AppColors.primary, width: 15)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, color: AppColors.primary, width: 15)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13, color: AppColors.primary, width: 15)]),
        ],
      ),
    );
  }
}