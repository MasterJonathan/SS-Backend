import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/kawanss_model.dart'; // Import model yang sudah ada
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KawanssPage extends StatefulWidget {
  const KawanssPage({super.key});

  @override
  State<KawanssPage> createState() => _KawanssPageState();
}

class _KawanssPageState extends State<KawanssPage> {
  // Mock data menggunakan KawanssModel yang sudah ada
  final List<KawanssModel> _kawanssData = [
    KawanssModel(id: '1', title: '11.22: Kecelakaan Melibatkan Motor Terjatuh di Dekat TL Dekat, Lamongan', jumlahLike: 0, jumlahComment: 0, deleted: false, uploadDate: DateTime(2025, 3, 17, 11, 28, 28), accountName: 'Roudotun Nadifah', jumlahLaporan: 0, userId: 'user1'),
    KawanssModel(id: '2', title: '11.09: Tol Waru arah Satelit dan Raya Tandes arah Tanjungsari Macet...', jumlahLike: 0, jumlahComment: 0, deleted: false, uploadDate: DateTime(2025, 3, 17, 11, 27, 23), accountName: 'Roudotun Nadifah', jumlahLaporan: 0, userId: 'user2'),
    KawanssModel(id: '3', title: '10.50: Ada Kendaraan Alat Berat Mogok di Jalan Mayjen Sungkono...', jumlahLike: 0, jumlahComment: 0, deleted: false, uploadDate: DateTime(2025, 3, 17, 10, 51, 43), accountName: 'Roudotun Nadifah', jumlahLaporan: 3, userId: 'user3'),
    KawanssModel(id: '4', title: '10.43: Raya Bambe arah Mastrip Karangpilang, Tebel arah Gedangan...', jumlahLike: 0, jumlahComment: 0, deleted: false, uploadDate: DateTime(2025, 3, 17, 10, 44, 32), accountName: 'Roudotun Nadifah', jumlahLaporan: 1, userId: 'user4'),
    KawanssModel(id: '5', title: '10.25: Exit Tol Perak arah Bundaran Kodikal, Raya Gilang', jumlahLike: 0, jumlahComment: 0, deleted: false, uploadDate: DateTime(2025, 3, 17, 10, 27, 15), accountName: 'Roudotun Nadifah', jumlahLaporan: 5, userId: 'user5'),
  ];

  late List<KawanssModel> _filteredData;
  String _searchTerm = "";
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');
  String _entriesToShow = '10';

  @override
  void initState() {
    super.initState();
    _filteredData = _kawanssData;
  }

  void _filterData(String query) {
    setState(() {
      _searchTerm = query;
      if (query.isEmpty) {
        _filteredData = _kawanssData;
      } else {
        _filteredData = _kawanssData
            .where((item) =>
                (item.title?.toLowerCase() ?? '').contains(query.toLowerCase()) ||
                (item.accountName?.toLowerCase() ?? '').contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey('kawanssPage'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          CustomCard(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Tambah Kawan SS'),
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                _buildTableControls(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildDataTable(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kawan SS Management',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Halaman untuk mengatur Kawan SS',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.foreground.withOpacity(0.6)),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.home, color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Text('Home', style: TextStyle(color: AppColors.primary)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: AppColors.foreground.withOpacity(0.5), size: 18),
            const SizedBox(width: 4),
            Text('Kawan SS Management', style: TextStyle(color: AppColors.foreground)),
          ],
        )
      ],
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
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.foreground.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _entriesToShow,
                  items: <String>['10', '25', '50', '100'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _entriesToShow = newValue!;
                    });
                  },
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
            decoration: const InputDecoration(
              labelText: 'Search:',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: _filterData,
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
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
      rows: _filteredData.map((item) {
        // Logika untuk Status: !deleted berarti aktif
        bool isActive = !item.deleted;

        return DataRow(cells: [
          DataCell(
            Row(
              children: [
                _actionButton(icon: Icons.edit, color: AppColors.primary, tooltip: 'Edit'),
                const SizedBox(width: 4),
                _actionButton(icon: Icons.close, color: AppColors.error, tooltip: 'Delete'),
                const SizedBox(width: 4),
                _actionButton(icon: Icons.search, color: AppColors.warning, tooltip: 'View Details'),
                const SizedBox(width: 4),
                _actionButton(icon: Icons.notifications, color: Colors.blue, tooltip: 'Send Notification'),
              ],
            ),
          ),
          DataCell(
            SizedBox(
              width: 250,
              child: Text(item.title ?? '-'), // Gunakan field 'title'
            ),
          ),
          DataCell(const Text('-')), // Field Kategori tidak ada di model
          DataCell(Text(item.jumlahLaporan.toString())), // Gunakan 'jumlahLaporan' sebagai 'Dilihat'
          DataCell(Text(item.jumlahLike.toString())), // Gunakan 'jumlahLike'
          DataCell(Text(item.jumlahComment.toString())), // Gunakan 'jumlahComment'
          DataCell(
            Icon(
              isActive ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isActive ? AppColors.success : AppColors.foreground.withOpacity(0.5),
            ),
          ),
          DataCell(Text(_dateFormatter.format(item.uploadDate))), // Gunakan 'uploadDate'
          DataCell(Text(_dateFormatter.format(item.uploadDate))), // Gunakan 'uploadDate'
          DataCell(Text(item.accountName ?? '-')), // Gunakan 'accountName' sebagai 'Diposting Oleh'
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
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Tooltip(
          message: tooltip,
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }
}