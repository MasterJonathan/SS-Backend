import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/kawanss_model.dart';
import 'package:admin_dashboard_template/providers/kawanss_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class KawanssPage extends StatefulWidget {
  const KawanssPage({super.key});

  @override
  State<KawanssPage> createState() => _KawanssPageState();
}

class _KawanssPageState extends State<KawanssPage> {
  // Gunakan _filteredData dari state
  late List<KawanssModel> _filteredData;
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');
  String _entriesToShow = '10';

  @override
  void initState() {
    super.initState();
    // Inisialisasi awal _filteredData
    final provider = Provider.of<KawanssProvider>(context, listen: false);
    _filteredData = provider.kawanssList;

    // Listener hanya untuk memicu rebuild saat teks berubah
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Metode filter yang aman untuk dipanggil dari build
  void _performFilter(String query, List<KawanssModel> allData) {
    if (query.isEmpty) {
      _filteredData = allData;
    } else {
      _filteredData =
          allData
              .where(
                (item) =>
                    (item.title?.toLowerCase() ?? '').contains(
                      query.toLowerCase(),
                    ) ||
                    (item.accountName?.toLowerCase() ?? '').contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KawanssProvider>(
      builder: (context, provider, child) {
        // --- LOGIKA FILTER YANG BENAR ---
        _performFilter(_searchController.text, provider.kawanssList);
        // ------------------------------------

        return Column(
          key: const PageStorageKey('kawanssPage'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                CustomCard(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Tambah Kawan SS'),
                        onPressed: () {
                          /* TODO: Implement Add Dialog */
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTableControls(),
                      const SizedBox(height: 20),
                      if (provider.state == KawanssViewState.Busy &&
                          provider.kawanssList.isEmpty)
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
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTableControls() {
    // ... (kode table controls tidak berubah)
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
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
        SizedBox(
          width: 250,
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search:',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable(KawanssProvider provider) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Aksi')),
        DataColumn(label: Text('Judul')),
        DataColumn(label: Text('Kategori')),
        DataColumn(label: Text('Dilihat')),
        DataColumn(label: Text('Like')),
        DataColumn(label: Text('Comment')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Tanggal\nPublish')),
        DataColumn(label: Text('Tanggal\nPosting')),
        DataColumn(label: Text('Diposting\nOleh')),
      ],
      rows:
          _filteredData.map((item) {
            // ... (kode DataRow tidak berubah)
            bool isActive = !item.deleted;
            return DataRow(
              cells: [
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
                            () async => await provider.deleteKawanss(item.id),
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
                DataCell(SizedBox(width: 250, child: Text(item.title ?? '-'))),
                DataCell(const Text('-')),
                DataCell(Text(item.jumlahLaporan.toString())),
                DataCell(Text(item.jumlahLike.toString())),
                DataCell(Text(item.jumlahComment.toString())),
                DataCell(
                  Icon(
                    isActive
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color:
                        isActive
                            ? AppColors.success
                            : AppColors.foreground.withOpacity(0.5),
                  ),
                ),
                DataCell(Text(_dateFormatter.format(item.uploadDate))),
                DataCell(Text(_dateFormatter.format(item.uploadDate))),
                DataCell(Text(item.accountName ?? '-')),
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
