import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/kontributor_model.dart';
import 'package:admin_dashboard_template/providers/kontributor_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class KontributorPostPage extends StatefulWidget {
  const KontributorPostPage({super.key});

  @override
  State<KontributorPostPage> createState() => _KontributorPostPageState();
}

class _KontributorPostPageState extends State<KontributorPostPage> {
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');

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
    return Consumer<KontributorProvider>(
      builder: (context, provider, child) {
        
        List<KontributorModel> filteredData;
        final query = _searchController.text.toLowerCase();
        final allData = provider.kontributors;

        if (query.isEmpty) {
          filteredData = allData;
        } else {
          filteredData = allData.where((item) =>
            (item.deskripsi?.toLowerCase() ?? '').contains(query) ||
            (item.accountName?.toLowerCase() ?? '').contains(query)
          ).toList();
        }
        

        return Column(
          key: const PageStorageKey('kontributorPostPage'),
          children: [Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

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
                    if (provider.state == KontributorViewState.Busy && provider.kontributors.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else if (provider.errorMessage != null)
                      Center(child: Text('Error: ${provider.errorMessage}', style: TextStyle(color: AppColors.error)))
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


  Widget _buildSearchField() {
    
    return SizedBox(
      width: 250,
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(labelText: 'Search:', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      ),
    );
  }

  
  Widget _buildDataTable(KontributorProvider provider, List<KontributorModel> filteredData) {
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
      
      rows: filteredData.map((item) {
        
        bool isActive = !item.deleted;
        String jenisStatus = item.deleted ? 'Dihapus Kontributor' : 'Aktif';

        return DataRow(cells: [
          DataCell(
            Row(
              children: [
                _actionButton(
                  icon: Icons.delete_outline,
                  color: AppColors.error,
                  tooltip: 'Hapus Postingan',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Konfirmasi Hapus'),
                        content: Text('Anda yakin ingin menghapus postingan "${item.deskripsi?.substring(0, (item.deskripsi?.length ?? 0) > 20 ? 20 : (item.deskripsi?.length ?? 0))}..."?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Hapus', style: TextStyle(color: AppColors.error))),
                        ],
                      ),
                    );
                    if (confirm ?? false) {
                      await provider.deleteKontributor(item.id);
                    }
                  },
                ),
                const SizedBox(width: 4),
                _actionButton(
                  icon: isActive ? Icons.unpublished_outlined : Icons.check_circle_outline,
                  color: isActive ? AppColors.warning : AppColors.success,
                  tooltip: isActive ? 'Nonaktifkan (Hapus)' : 'Aktifkan Kembali',
                  onPressed: () async {
                    final updatedItem = KontributorModel(
                      id: item.id,
                      deleted: !item.deleted,
                      accountName: item.accountName,
                      deskripsi: item.deskripsi,
                      email: item.email,
                      gambar: item.gambar,
                      judul: item.judul,
                      jumlahComment: item.jumlahComment,
                      jumlahLaporan: item.jumlahLaporan,
                      jumlahLike: item.jumlahLike,
                      kontributorPhotoURL: item.kontributorPhotoURL,
                      lokasi: item.lokasi,
                      telepon: item.telepon,
                      uploadDate: item.uploadDate,
                      userId: item.userId,
                    );
                    await provider.updateKontributor(updatedItem);
                  },
                ),
              ],
            ),
          ),
          DataCell(SizedBox(width: 250, child: Text(item.deskripsi ?? '-', maxLines: 4, overflow: TextOverflow.ellipsis))),
          DataCell(Text(_dateFormatter.format(item.uploadDate))),
          DataCell(
            (item.gambar != null && item.gambar!.isNotEmpty)
            ? SizedBox(width: 100, height: 50, child: Image.network(item.gambar!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: AppColors.error)))
            : const Text('-'),
          ),
          DataCell(Text(item.jumlahLaporan.toString())),
          DataCell(Text(item.jumlahLike.toString())),
          DataCell(Text(item.jumlahComment.toString())),
          DataCell(Icon(isActive ? Icons.check_circle : Icons.radio_button_unchecked, color: isActive ? AppColors.success : AppColors.foreground.withOpacity(0.5))),
          DataCell(Text(jenisStatus)),
          DataCell(Text(_dateFormatter.format(item.uploadDate))),
          DataCell(Text(item.accountName ?? '-', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500))),
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