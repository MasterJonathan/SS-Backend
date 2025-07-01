import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/kontributor_model.dart'; // Import model yang sudah diperbarui
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KontributorManagementPage extends StatefulWidget {
  const KontributorManagementPage({super.key});

  @override
  State<KontributorManagementPage> createState() => _KontributorManagementPageState();
}

class _KontributorManagementPageState extends State<KontributorManagementPage> {
  // Data mock disesuaikan dengan model yang sudah lengkap
  final List<KontributorModel> _kontributorData = [
    KontributorModel(id: '1', accountName: 'Nanang', email: 'pr1y4nto19@gmail.com', lokasi: 'Sidoarjo', telepon: '82337899819', deleted: true, uploadDate: DateTime(2025, 3, 17, 10, 23, 57), jumlahComment: 0, jumlahLaporan: 0, jumlahLike: 0),
    KontributorModel(id: '2', accountName: 'Rasat Pamuji', email: 'rasatp@gmail.com', lokasi: 'Tambakboyo, Tawangasri, Sukoharjo, Jawa Tengah', telepon: '085743559070', deleted: false, uploadDate: DateTime(2025, 3, 16, 14, 42, 59), jumlahComment: 0, jumlahLaporan: 0, jumlahLike: 0),
    KontributorModel(id: '3', accountName: 'Aries susanto', email: 'citra.plastik.cp@gmail.com', lokasi: 'Jl.tenggumung baru selatan gang 11 no.1', telepon: '081231231047', deleted: true, uploadDate: DateTime(2025, 3, 16, 10, 39, 53), jumlahComment: 0, jumlahLaporan: 0, jumlahLike: 0),
    KontributorModel(id: '4', accountName: 'Aries susanto', email: 'cplastik342@gmail.com', lokasi: 'Jl.tenggumung baru selatan gang 11 no.1', telepon: '081231231047', deleted: true, uploadDate: DateTime(2025, 3, 16, 10, 34, 44), jumlahComment: 0, jumlahLaporan: 0, jumlahLike: 0),
  ];

  late List<KontributorModel> _filteredData;
  String _searchTerm = "";
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');

  @override
  void initState() {
    super.initState();
    _filteredData = _kontributorData;
  }

  void _filterData(String query) {
    setState(() {
      _searchTerm = query;
      if (query.isEmpty) {
        _filteredData = _kontributorData;
      } else {
        _filteredData = _kontributorData
            .where((item) =>
                (item.accountName?.toLowerCase() ?? '').contains(query.toLowerCase()) ||
                (item.email?.toLowerCase() ?? '').contains(query.toLowerCase()) ||
                (item.lokasi?.toLowerCase() ?? '').contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey('kontributorManagementPage'),
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
                _buildActionButtons(),
                const SizedBox(height: 20),
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
              'Kontributor Management',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Halaman untuk memanage Kontributor',
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
            Text('Kontributor Management', style: TextStyle(color: AppColors.foreground)),
          ],
        )
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Tambah Kontributor'),
          onPressed: () {},
        ),
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
        DataColumn(label: Text('Nama\nKontributor')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Alamat')),
        DataColumn(label: Text('Telepon')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Jenis\nStatus')),
        DataColumn(label: Text('Tanggal\nPosting')),
      ],
      rows: _filteredData.map((item) {
        bool isActive = !item.deleted;
        return DataRow(cells: [
          DataCell(
            Row(
              children: [
                _actionButton(icon: Icons.edit, color: AppColors.primary, tooltip: 'Edit'),
                const SizedBox(width: 4),
                _actionButton(icon: Icons.search, color: AppColors.primary, tooltip: 'View'),
                const SizedBox(width: 4),
                _actionButton(icon: Icons.email, color: AppColors.primary, tooltip: 'Send Email'),
              ],
            ),
          ),
          DataCell(Text(item.accountName ?? '-')),
          DataCell(Text(item.email ?? '-')),
          DataCell(
            SizedBox(
              width: 200,
              child: Text(item.lokasi ?? '-', maxLines: 3, overflow: TextOverflow.ellipsis),
            ),
          ),
          DataCell(Text(item.telepon ?? '-')),
          DataCell(
            Icon(
              isActive ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isActive ? AppColors.success : AppColors.foreground.withOpacity(0.5),
            ),
          ),
          DataCell(Text(isActive ? 'Aktif' : 'Belum Diaktifkan')),
          DataCell(Text(_dateFormatter.format(item.uploadDate))),
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