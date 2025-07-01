import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/banner_model.dart'; // Import model
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BannerTopPage extends StatefulWidget {
  const BannerTopPage({super.key});

  @override
  State<BannerTopPage> createState() => _BannerTopPageState();
}

class _BannerTopPageState extends State<BannerTopPage> {
  // Mock data based on the image
  final List<BannerTopModel> _banners = [
    BannerTopModel(id: '1', namaBanner: 'Indonesia Bangkit', tanggalAktifMulai: DateTime(2020, 11, 17, 2, 39), tanggalAktifSelesai: DateTime(2021, 1, 31, 12, 0), bannerImageUrl: 'https://via.placeholder.com/300x50/FF0000/FFFFFF?Text=Indonesia+Bangkit', status: false, hits: 7692, tanggalPosting: DateTime(2020, 11, 17, 14, 57, 1), dipostingOleh: 'Grafis New Media'),
    BannerTopModel(id: '2', namaBanner: 'Visual Radio', tanggalAktifMulai: DateTime(2023, 4, 10, 11, 30), tanggalAktifSelesai: DateTime(2023, 5, 10, 11, 31), bannerImageUrl: 'https://via.placeholder.com/300x50/0000FF/FFFFFF?Text=Visual+Radio+LIVE', status: true, hits: 7023, tanggalPosting: DateTime(2023, 4, 10, 11, 33, 24), dipostingOleh: 'Sugeng'),
    BannerTopModel(id: '3', namaBanner: 'SURABAYA BERGERAK UPDATE', tanggalAktifMulai: DateTime(2022, 11, 9, 8, 9), tanggalAktifSelesai: DateTime(2022, 12, 31, 8, 9), bannerImageUrl: 'https://via.placeholder.com/300x50/000000/FFFFFF?Text=Surabaya+Bergerak', status: true, hits: 4039, tanggalPosting: DateTime(2022, 11, 9, 20, 13, 10), dipostingOleh: 'Administrator'),
    BannerTopModel(id: '4', namaBanner: 'YAMAHA 08 JUNI 2023', tanggalAktifMulai: DateTime(2023, 6, 8, 11, 43), tanggalAktifSelesai: DateTime(2023, 6, 21, 11, 59), bannerImageUrl: 'https://via.placeholder.com/300x50/333333/FFFFFF?Text=Yamaha+WRC', status: true, hits: 1879, tanggalPosting: DateTime(2023, 6, 8, 11, 50, 40), dipostingOleh: 'Grafis New Media'),
    BannerTopModel(id: '5', namaBanner: 'Yamaha Mei 2023', tanggalAktifMulai: DateTime(2023, 5, 13, 12, 0), tanggalAktifSelesai: DateTime(2023, 5, 26, 12, 19, 51), bannerImageUrl: 'https://via.placeholder.com/300x50/007bff/FFFFFF?Text=Yamaha+Blue', status: true, hits: 1471, tanggalPosting: DateTime(2023, 5, 13, 12, 19, 51), dipostingOleh: 'Sugeng'),
  ];

  late List<BannerTopModel> _filteredBanners;
  String _searchTerm = "";
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');
  final DateFormat _rangeDateFormatter = DateFormat('dd MMMM yyyy HH:mm:ss');
  String _entriesToShow = '10';

  @override
  void initState() {
    super.initState();
    _filteredBanners = _banners;
  }

  void _filterBanners(String query) {
    setState(() {
      _searchTerm = query;
      if (query.isEmpty) {
        _filteredBanners = _banners;
      } else {
        _filteredBanners = _banners
            .where((banner) =>
                banner.namaBanner.toLowerCase().contains(query.toLowerCase()) ||
                banner.dipostingOleh.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey('bannerTopPage'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header dan Breadcrumb
          _buildHeader(),
          const SizedBox(height: 24),

          // 2. Konten utama di dalam CustomCard
          CustomCard(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol Tambah
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Tambah Banner Top Kawan SS'),
                  onPressed: () {
                    // Logic untuk membuka dialog/halaman tambah banner
                  },
                ),
                const SizedBox(height: 20),

                // Kontrol entri dan pencarian
                _buildTableControls(),
                const SizedBox(height: 20),
                
                // Tabel Data
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
              'Banner Top Kawan SS Management',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Halaman untuk mengatur Banner Top Kawan SS',
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
            Text('Banner Top Kawan SS Management', style: TextStyle(color: AppColors.foreground)),
          ],
        )
      ],
    );
  }
  
  Widget _buildTableControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Kontrol 'Show entries'
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
                      // Logic to refresh table data with new entry limit
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('entries'),
          ],
        ),
        // Kotak 'Search'
        SizedBox(
          width: 250,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search:',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: _filterBanners,
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return DataTable(
      // Theming diambil dari AppTheme
      columns: const [
        DataColumn(label: Text('Aksi')),
        DataColumn(label: Text('Nama Banner\nTop')),
        DataColumn(label: Text('Tanggal Aktif')),
        DataColumn(label: Text('Banner Top')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Hits')),
        DataColumn(label: Text('Tanggal\nPosting')),
        DataColumn(label: Text('Diposting\nOleh')),
      ],
      rows: _filteredBanners.map((banner) {
        return DataRow(cells: [
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  color: AppColors.primary,
                  onPressed: () {},
                  tooltip: 'Edit Banner',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: AppColors.error,
                  onPressed: () {},
                  tooltip: 'Delete Banner',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          DataCell(Text(banner.namaBanner)),
          DataCell(
            Text(
              '${_rangeDateFormatter.format(banner.tanggalAktifMulai)} Sampai\n${_rangeDateFormatter.format(banner.tanggalAktifSelesai)}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          DataCell(
            SizedBox(
              width: 200, // Beri lebar agar banner tidak terlalu kecil
              child: Image.network(
                banner.bannerImageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, color: AppColors.error);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          DataCell(
            Icon(
              banner.status ? Icons.check_circle : Icons.radio_button_unchecked,
              color: banner.status ? AppColors.success : AppColors.foreground.withOpacity(0.5),
            ),
          ),
          DataCell(Text(banner.hits.toString())),
          DataCell(Text(_dateFormatter.format(banner.tanggalPosting))),
          DataCell(Text(banner.dipostingOleh)),
        ]);
      }).toList(),
    );
  }
}