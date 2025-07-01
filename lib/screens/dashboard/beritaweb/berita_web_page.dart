import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/news_model.dart'; // Import model
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BeritaWebPage extends StatefulWidget {
  const BeritaWebPage({super.key});

  @override
  State<BeritaWebPage> createState() => _BeritaWebPageState();
}

class _BeritaWebPageState extends State<BeritaWebPage> {
  // Mock data based on the image
  final List<NewsModel> _newsData = [
    NewsModel(id: '1', judul: 'Divpropam Polri Gelar Sidang Etik Mantan Kapolres Ngada Hari Ini', lead: '“Memang jadwal sidangnya pagi ini, makanya kami datang untuk mengawasi secara langsung bagaimana proses sidang itu diselenggarakan,” ucapnya.', tanggalPublish: DateTime(2025, 3, 17, 11, 30, 18), category: 'Kelana Kota', dilihat: 0, like: 0, status: true, tanggalPosting: DateTime(2025, 3, 17, 11, 31, 02), dipostingOleh: 'Grab System'),
    NewsModel(id: '2', judul: 'Harga Pangan Awal Pekan: Cabai Rawit Merah Rp87.500/kg, Telur Ayam Ras Rp35.450/kg', lead: 'Pusat Informasi Harga Pangan Strategis (PIHPS) Nasional yang dikelola Bank Indonesia mencatat, harga cabai rawit merah pada Senin (17/3/2025) pagi, di tingkat pedagang eceran mencapai Rp87.500 per kilogram...', tanggalPublish: DateTime(2025, 3, 17, 11, 19, 35), category: 'Ekonomi Bisnis', dilihat: 0, like: 0, status: true, tanggalPosting: DateTime(2025, 3, 17, 11, 20, 04), dipostingOleh: 'Grab System'),
    NewsModel(id: '3', judul: 'AS Yakin ByteDance Bakal Sepakat Soal Penjualan TikTok Sebelum 5 April', lead: 'JD Vance Wakil Presiden AS menyatakan bahwa penjualan ini perlu dilakukan agar TikTok tetap dapat beroperasi di AS.', tanggalPublish: DateTime(2025, 3, 17, 11, 2, 26), category: 'Kelana Kota', dilihat: 0, like: 0, status: true, tanggalPosting: DateTime(2025, 3, 17, 11, 3, 2), dipostingOleh: 'Grab System'),
    NewsModel(id: '4', judul: 'Rupiah Menguat Seiring Dolar AS Masih Dibayangi Sentimen', lead: '“Dolar AS kemungkinan masih dibayangi sentimen negatif karena pasar berekspektasi bahwa kebijakan kenaikan tarif Trump bisa mendorong bank sentral lain untuk melakukan intervensi,” kata Analis Pasar Mata Uang, Ibrahim Assuaibi, Senin (17/3/2025).', tanggalPublish: DateTime(2025, 3, 17, 10, 51, 5), category: 'Ekonomi Bisnis', dilihat: 1, like: 0, status: true, tanggalPosting: DateTime(2025, 3, 17, 11, 0, 4), dipostingOleh: 'Grab System'),
  ];

  late List<NewsModel> _filteredData;
  String _searchTerm = "";
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');
  String _entriesToShow = '10';

  @override
  void initState() {
    super.initState();
    _filteredData = _newsData;
  }

  void _filterData(String query) {
    setState(() {
      _searchTerm = query;
      if (query.isEmpty) {
        _filteredData = _newsData;
      } else {
        _filteredData = _newsData
            .where((item) =>
                item.judul.toLowerCase().contains(query.toLowerCase()) ||
                item.lead.toLowerCase().contains(query.toLowerCase()) ||
                item.category.toLowerCase().contains(query.toLowerCase()) ||
                item.dipostingOleh.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey('beritaWebPage'),
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
              'Berita Web Management',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Halaman untuk Berita Web di CMS',
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
            Text('Berita Web Management', style: TextStyle(color: AppColors.foreground)),
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
        DataColumn(label: Text('Lead')),
        DataColumn(label: Text('Tanggal\nPublish')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Dilihat')),
        DataColumn(label: Text('Like')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Tanggal\nPosting')),
        DataColumn(label: Text('Diposting\nOleh')),
      ],
      rows: _filteredData.map((item) {
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
          DataCell(
            SizedBox(
              width: 200, // Beri lebar agar teks judul tidak wrap terlalu banyak
              child: Text(item.judul),
            ),
          ),
          DataCell(
            SizedBox(
              width: 300, // Beri lebar untuk paragraf lead
              child: Text(item.lead, maxLines: 3, overflow: TextOverflow.ellipsis),
            ),
          ),
          DataCell(Text(_dateFormatter.format(item.tanggalPublish))),
          DataCell(Text(item.category)),
          DataCell(Text(item.dilihat.toString())),
          DataCell(Text(item.like.toString())),
          DataCell(
            Icon(
              item.status ? Icons.check_circle : Icons.radio_button_unchecked,
              color: item.status ? AppColors.success : AppColors.foreground.withOpacity(0.5),
            ),
          ),
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