import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/dashboard/infoss/infoss_model.dart';
import 'package:admin_dashboard_template/providers/dashboard/infoss/infoss_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InfossPage extends StatefulWidget {
  const InfossPage({super.key});

  @override
  State<InfossPage> createState() => _InfossPageState();
}

class _InfossPageState extends State<InfossPage> {
  late List<InfossModel> _filteredData;
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');
  String _entriesToShow = '10';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<InfossProvider>(context, listen: false);
    _filteredData = provider.infossList;

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performFilter(String query, List<InfossModel> allData) {
    if (query.isEmpty) {
      _filteredData = allData;
    } else {
      _filteredData =
          allData
              .where(
                (item) =>
                    (item.judul?.toLowerCase() ?? '').contains(
                      query.toLowerCase(),
                    )
              )
              .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfossProvider>(
      builder: (context, provider, child) {
        _performFilter(_searchController.text, provider.infossList);

        return Column(
          key: const PageStorageKey('kawanssPage'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomCard(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTableControls(),
                        const SizedBox(height: 20),
                        if (provider.state == InfossViewState.Busy &&
                            provider.infossList.isEmpty)
                          const Center(child: CircularProgressIndicator())
                        else if (provider.errorMessage != null)
                          Center(child: Text('Error: ${provider.errorMessage}'))
                        else
                          SizedBox(
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: _buildDataTable(provider),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTableControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Show'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.foreground.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _entriesToShow,
                  items:
                      <String>['10', '25', '50', '100']
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (String? newValue) =>
                          setState(() => _entriesToShow = newValue!),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('entries'),
          ],
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Tambah Info SS'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDataTable(InfossProvider provider) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Judul')),
        DataColumn(label: Text('Kategori')),
        DataColumn(label: Text('Dilihat')),
        DataColumn(label: Text('Like')),
        DataColumn(label: Text('Comment')),
        // DataColumn(label: Text('Status')),
        DataColumn(label: Text('Tanggal\nPublish')),
        // DataColumn(label: Text('Tanggal\nPosting')),
        // DataColumn(label: Text('Diposting\nOleh')),
        DataColumn(label: Text('Aksi')),
      ],
      rows:
          _filteredData.map((item) {
            // bool isActive = !item.deleted;
            return DataRow(
              cells: [
                DataCell(SizedBox(width: 250, child: Text(item.judul ?? '-'))),
                DataCell(Text(item.kategori ?? '-')),
                DataCell(Text(item.jumlahView.toString())),
                DataCell(Text(item.jumlahLike.toString())),
                DataCell(Text(item.jumlahComment.toString())),
                // DataCell(
                //   Chip(
                //     label: Text(isActive ? 'Active' : 'Inactive'),
                //     backgroundColor:
                //         isActive
                //             ? AppColors.success.withOpacity(0.1)
                //             : AppColors.error.withOpacity(0.1),
                //     labelStyle: TextStyle(
                //       color: isActive ? AppColors.success : AppColors.error,
                //     ),
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 8,
                //       vertical: 2,
                //     ),
                //   ),
                // ), 
                DataCell(Text(_dateFormatter.format(item.uploadDate))),
                DataCell(
                  Row(
                    children: [
                      _actionButton(
                        icon: Icons.edit,
                        color: AppColors.primary,
                        tooltip: 'Edit',
                      ),
                      const SizedBox(width: 4),
                      _actionButton(
                        icon: Icons.close,
                        color: AppColors.error,
                        tooltip: 'Delete',
                        onPressed:
                            () async => await provider.deleteInfoss(item.id),
                      ),
                      const SizedBox(width: 4),
                      _actionButton(
                        icon: Icons.search,
                        color: AppColors.warning,
                        tooltip: 'View Details',
                      ),
                      const SizedBox(width: 4),
                      _actionButton(
                        icon: Icons.notifications,
                        color: Colors.blue,
                        tooltip: 'Send Notification',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 32,
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Tooltip(message: tooltip, child: Icon(icon, size: 16)),
      ),
    );
  }
}
