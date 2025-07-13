import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/banner_model.dart';
import 'package:admin_dashboard_template/providers/banner_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BannerTopPage extends StatefulWidget {
  const BannerTopPage({super.key});

  @override
  State<BannerTopPage> createState() => _BannerTopPageState();
}

class _BannerTopPageState extends State<BannerTopPage> {
  late List<BannerTopModel> _filteredData;
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');
  final DateFormat _rangeDateFormatter = DateFormat('dd MMMM yyyy HH:mm:ss');
  String _entriesToShow = '10';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BannerProvider>(context, listen: false);
    _filteredData = provider.banners;

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performFilter(String query, List<BannerTopModel> allBanners) {
    if (query.isEmpty) {
      _filteredData = allBanners;
    } else {
      _filteredData =
          allBanners.where((banner) {
            final namaBanner = banner.namaBanner.toLowerCase();
            final dipostingOleh = banner.dipostingOleh.toLowerCase();
            return namaBanner.contains(query.toLowerCase()) ||
                dipostingOleh.contains(query.toLowerCase());
          }).toList();
    }
  }

  void _showAddEditDialog({BannerTopModel? banner}) {
    final isEditing = banner != null;
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: banner?.namaBanner);
    final imageUrlController = TextEditingController(
      text: banner?.bannerImageUrl,
    );

    // State untuk tanggal dan waktu, diinisialisasi dengan data yang ada atau default
    DateTime tanggalMulai = banner?.tanggalAktifMulai ?? DateTime.now();
    DateTime tanggalSelesai =
        banner?.tanggalAktifSelesai ??
        DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (context) {
        // Gunakan StatefulWidget di dalam dialog untuk mengelola state tanggal
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Helper untuk memilih tanggal dan waktu
            Future<void> selectDate(
              BuildContext context,
              bool isStartDate,
            ) async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: isStartDate ? tanggalMulai : tanggalSelesai,
                firstDate: DateTime(2020),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                // Setelah memilih tanggal, langsung buka pemilih waktu
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                    isStartDate ? tanggalMulai : tanggalSelesai,
                  ),
                );
                if (pickedTime != null) {
                  setStateDialog(() {
                    if (isStartDate) {
                      tanggalMulai = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    } else {
                      tanggalSelesai = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    }
                  });
                }
              }
            }

            return AlertDialog(
              title: Text(isEditing ? 'Edit Banner' : 'Tambah Banner'),
              content: Form(
                key: formKey,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 400),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: namaController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Banner',
                          ),
                          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: imageUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                          ),
                          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 20),

                        // --- INPUT TANGGAL & WAKTU BARU ---
                        Text(
                          'Tanggal Aktif Mulai',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => selectDate(context, true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                            child: Text(
                              DateFormat(
                                'dd MMMM yyyy, HH:mm',
                              ).format(tanggalMulai),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tanggal Aktif Selesai',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => selectDate(context, false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                            child: Text(
                              DateFormat(
                                'dd MMMM yyyy, HH:mm',
                              ).format(tanggalSelesai),
                            ),
                          ),
                        ),
                        // ------------------------------------
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final provider = context.read<BannerProvider>();
                      final now = DateTime.now();

                      if (isEditing) {
                        final updatedBanner = BannerTopModel(
                          id: banner.id,
                          namaBanner: namaController.text,
                          bannerImageUrl: imageUrlController.text,
                          tanggalAktifMulai:
                              tanggalMulai, // Gunakan tanggal dari state dialog
                          tanggalAktifSelesai:
                              tanggalSelesai, // Gunakan tanggal dari state dialog
                          status: banner.status,
                          hits: banner.hits,
                          tanggalPosting: banner.tanggalPosting,
                          dipostingOleh: banner.dipostingOleh,
                        );
                        await provider.updateBanner(updatedBanner);
                      } else {
                        final newBanner = BannerTopModel(
                          id: '',
                          namaBanner: namaController.text,
                          bannerImageUrl: imageUrlController.text,
                          tanggalAktifMulai:
                              tanggalMulai, // Gunakan tanggal dari state dialog
                          tanggalAktifSelesai:
                              tanggalSelesai, // Gunakan tanggal dari state dialog
                          status: true,
                          hits: 0,
                          tanggalPosting: now,
                          dipostingOleh: 'Admin',
                        );
                        await provider.addBanner(newBanner);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(
      builder: (context, provider, child) {
        _performFilter(_searchController.text, provider.banners);

        return Column(
          key: const PageStorageKey('bannerTopPage'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTableControls(),
                  const SizedBox(height: 20),
                  if (provider.state == BannerViewState.Busy &&
                      provider.banners.isEmpty)
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
          label: const Text('Tambah Banner Top Kawan SS'),
          onPressed: () => _showAddEditDialog(),
        ),
      ],
    );
  }

  Widget _buildDataTable(BannerProvider provider) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Nama Banner')),
        DataColumn(label: Text('Tanggal Aktif')),
        DataColumn(label: Text('Banner Top')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Hits')),
        DataColumn(label: Text('Tanggal\nPosting')),
        DataColumn(label: Text('Diposting\nOleh')),
        DataColumn(label: Text('Aksi')),
      ],
      rows:
          _filteredData.map((banner) {
            return DataRow(
              cells: [
                DataCell(Text(banner.namaBanner)),
                DataCell(
                  Text(
                    '${_rangeDateFormatter.format(banner.tanggalAktifMulai)} Sampai\n${_rangeDateFormatter.format(banner.tanggalAktifSelesai)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Image.network(
                      banner.bannerImageUrl,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (c, o, s) => const Icon(
                            Icons.image_not_supported,
                            color: AppColors.error,
                          ),
                    ),
                  ),
                ),

                DataCell(
                  Chip(
                    label: Text(banner.status ? 'Active' : 'Inactive'),
                    backgroundColor:
                        banner.status
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color:
                          banner.status ? AppColors.success : AppColors.error,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                  ),
                ),
                DataCell(Text(banner.hits.toString())),
                DataCell(Text(_dateFormatter.format(banner.tanggalPosting))),
                DataCell(Text(banner.dipostingOleh)),
                DataCell(
                  Row(
                    children: [
                      _actionButton(
                        icon: Icons.edit,
                        color: AppColors.primary,
                        tooltip: 'Edit Banner',
                        onPressed: () => _showAddEditDialog(banner: banner),
                      ),
                      const SizedBox(width: 8),
                      _actionButton(
                        icon: Icons.close,
                        color: AppColors.error,
                        tooltip: 'Delete Banner',
                        onPressed:
                            () async => await provider.deleteBanner(banner.id),
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
