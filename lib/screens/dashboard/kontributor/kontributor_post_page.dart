import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/kontributor_model.dart'; // Menggunakan model yang sudah ada
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KontributorPostPage extends StatefulWidget {
  const KontributorPostPage({super.key});

  @override
  State<KontributorPostPage> createState() => _KontributorPostPageState();
}

class _KontributorPostPageState extends State<KontributorPostPage> {
  // Mock data disesuaikan dengan field dari KontributorModel yang ada
  final List<KontributorModel> _kontributorPostData = [
    KontributorModel(id: '1', deskripsi: 'MERR tersendat dekat superindo. Ada dump truk ngeban', uploadDate: DateTime(2025, 3, 17, 8, 39, 10), gambar: 'https://via.placeholder.com/150/0000FF/FFFFFF?Text=Image1', jumlahLaporan: 4, jumlahLike: 0, jumlahComment: 0, deleted: false, accountName: 'Anton Reksohardjo', email: '', telepon: ''),
    KontributorModel(id: '2', deskripsi: 'Terkait dengan topik ini Saya punya pandangan yang berbeda, saya akan menyoroti bagaimana uang masyarakat kita mengalir deras ke arab Saudi sana, data...', uploadDate: DateTime(2025, 3, 17, 8, 30, 36), gambar: null, jumlahLaporan: 2, jumlahLike: 0, jumlahComment: 0, deleted: true, accountName: 'Yohanes Sukimon, SE', email: '', telepon: ''),
    KontributorModel(id: '3', deskripsi: 'Banyak orang di surabaya yang kehilangan akal sehat nya dan skarang banyak yang di rumah sakit jiwa... Karena mereka sudah pada hidup pas pasan,...', uploadDate: DateTime(2025, 3, 17, 7, 25, 25), gambar: null, jumlahLaporan: 18, jumlahLike: 0, jumlahComment: 0, deleted: false, accountName: 'Neo andreass', email: '', telepon: ''),
    KontributorModel(id: '4', deskripsi: 'Banyak orang di surabaya yang kehilangan akal sehat nya dan skarang banyak yang di rumah sakit jiwa... Karena mereka sudah pada hidup pas pasan,...', uploadDate: DateTime(2025, 3, 17, 7, 25, 17), gambar: null, jumlahLaporan: 2, jumlahLike: 0, jumlahComment: 0, deleted: false, accountName: 'Neo andreass', email: '', telepon: ''),
  ];

  late List<KontributorModel> _filteredData;
  String _searchTerm = "";
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');

  @override
  void initState() {
    super.initState();
    _filteredData = _kontributorPostData;
  }

  void _filterData(String query) {
    setState(() {
      _searchTerm = query;
      if (query.isEmpty) {
        _filteredData = _kontributorPostData;
      } else {
        _filteredData = _kontributorPostData
            .where((item) =>
                (item.deskripsi?.toLowerCase() ?? '').contains(query.toLowerCase()) ||
                (item.accountName?.toLowerCase() ?? '').contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey('kontributorPostPage'),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildSearchField(),
                ),
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
              'Post Kontributor Management',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Halaman untuk Post Kontributor di CMS',
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
            Text('Post Kontributor Management', style: TextStyle(color: AppColors.foreground)),
          ],
        )
      ],
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: 250,
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search:',
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: _filterData,
      ),
    );
  }

  Widget _buildDataTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Aksi')),
        DataColumn(label: Text('Judul')),
        DataColumn(label: Text('Tanggal\nPublish')),
        DataColumn(label: Text('Gambar')),
        DataColumn(label: Text('Dilihat')),
        DataColumn(label: Text('Like')),
        DataColumn(label: Text('Comment')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Jenis\nStatus')),
        DataColumn(label: Text('Tanggal\nPosting')),
        DataColumn(label: Text('Diposting\nOleh')),
      ],
      rows: _filteredData.map((item) {
        bool isActive = !item.deleted;
        String jenisStatus = item.deleted ? 'Dihapus Kontributor' : 'Aktif';

        return DataRow(cells: [
          DataCell(
            _actionButton(icon: Icons.search, color: AppColors.primary, tooltip: 'View Details'),
          ),
          DataCell(
            SizedBox(
              width: 250,
              child: Text(item.deskripsi ?? '-', maxLines: 4, overflow: TextOverflow.ellipsis),
            ),
          ),
          DataCell(Text(_dateFormatter.format(item.uploadDate))),
          DataCell(
            (item.gambar != null && item.gambar!.isNotEmpty)
            ? SizedBox(
                width: 100,
                height: 50,
                child: Image.network(
                  item.gambar!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: AppColors.error),
                ),
              )
            : const Text('-'),
          ),
          DataCell(Text(item.jumlahLaporan.toString())),
          DataCell(Text(item.jumlahLike.toString())),
          DataCell(Text(item.jumlahComment.toString())),
          DataCell(
            Icon(
              isActive ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isActive ? AppColors.success : AppColors.foreground.withOpacity(0.5),
            ),
          ),
          DataCell(Text(jenisStatus)),
          DataCell(Text(_dateFormatter.format(item.uploadDate))),
          DataCell(
            Text(item.accountName ?? '-', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
          ),
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