import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/news_model.dart';
import 'package:admin_dashboard_template/providers/news_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BeritaWebPage extends StatefulWidget {
  const BeritaWebPage({super.key});

  @override
  State<BeritaWebPage> createState() => _BeritaWebPageState();
}

class _BeritaWebPageState extends State<BeritaWebPage> {
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');
  String _entriesToShow = '10';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        
        List<NewsModel> filteredData;
        final query = _searchController.text.toLowerCase();
        final allData = provider.newsList;

        if (query.isEmpty) {
          filteredData = allData;
        } else {
          filteredData = allData.where((item) =>
            item.judul.toLowerCase().contains(query) ||
            item.lead.toLowerCase().contains(query)
          ).toList();
        }
        

        return Column(
          key: const PageStorageKey('beritaWebPage'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              CustomCard(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTableControls(),
                    const SizedBox(height: 20),
                    if (provider.state == NewsViewState.Busy && provider.newsList.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else if (provider.errorMessage != null)
                      Center(child: Text('Error: ${provider.errorMessage}'))
                    else
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          
                          child: _buildDataTable(provider, filteredData),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ]);
      },
    );
  }

  
  Widget _buildTableControls() {
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text('Show'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: AppColors.foreground.withOpacity(0.2)), borderRadius: BorderRadius.circular(4)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _entriesToShow,
                  items: <String>['10', '25', '50', '100'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                  onChanged: (String? newValue) => setState(() => _entriesToShow = newValue!),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('entries'),
          ],
        ),
        SizedBox(
          width: 250,
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(labelText: 'Search:', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
          ),
        ),
      ],
    );
  }

  
  Widget _buildDataTable(NewsProvider provider, List<NewsModel> filteredData) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Aksi')),
        DataColumn(label: Text('Judul')),
        DataColumn(label: Text('Lead')),
        DataColumn(label: Text('Tanggal\nPublish')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Dilihat')),
        DataColumn(label: Text('Like')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Tanggal\nPosting')),
        DataColumn(label: Text('Diposting\nOleh')),
      ],
      
      rows: filteredData.map((item) {
        
        return DataRow(cells: [
          DataCell(
            Row(
              children: [
                _actionButton(icon: Icons.search, color: AppColors.primary, tooltip: 'View Details'),
                const SizedBox(width: 4),
                _actionButton(icon: Icons.notifications, color: Colors.blue, tooltip: 'Send Notification'),
              ],
            ),
          ),
          DataCell(SizedBox(width: 200, child: Text(item.judul))),
          DataCell(SizedBox(width: 300, child: Text(item.lead, maxLines: 3, overflow: TextOverflow.ellipsis))),
          DataCell(Text(_dateFormatter.format(item.tanggalPublish))),
          DataCell(Text(item.category)),
          DataCell(Text(item.dilihat.toString())),
          DataCell(Text(item.like.toString())),
          DataCell(Icon(item.status ? Icons.check_circle : Icons.radio_button_unchecked, color: item.status ? AppColors.success : AppColors.foreground.withOpacity(0.5))),
          DataCell(Text(_dateFormatter.format(item.tanggalPosting))),
          DataCell(Text(item.dipostingOleh)),
        ]);
      }).toList(),
    );
  }

  Widget _actionButton({required IconData icon, required Color color, required String tooltip, VoidCallback? onPressed}) {
    return SizedBox(
      width: 32,
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), padding: EdgeInsets.zero),
        child: Tooltip(message: tooltip, child: Icon(icon, size: 16)),
      ),
    );
  }
}