import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/chat_message_model.dart'; // Import model
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago; // Import package timeago

class ChatManagementPage extends StatefulWidget {
  const ChatManagementPage({super.key});

  @override
  State<ChatManagementPage> createState() => _ChatManagementPageState();
}

class _ChatManagementPageState extends State<ChatManagementPage> {
  // Mock data based on the image
  final List<ChatMessageModel> _chatData = [
    ChatMessageModel(id: '1', kontributorName: 'Edy Darmanto', chatMessage: '[09:08] : Musim panas, banyak pohon peneduh yang dipapras, waras. Ta. Jarang pohon rubuh kecuali musim hujan.', status: true, tanggalPosting: DateTime(2024, 6, 19, 9, 8, 13)),
    ChatMessageModel(id: '2', kontributorName: 'Siswanto', chatMessage: '[08:52] : Hukum Lemah 🔥🔥🔥🔥', status: true, tanggalPosting: DateTime(2024, 6, 19, 8, 52, 21)),
    ChatMessageModel(id: '3', kontributorName: 'Hariszet', chatMessage: '[20:46] : Tolong info laka bruntun gerbang tol japanan arah sby', status: true, tanggalPosting: DateTime(2024, 6, 18, 20, 46, 53)),
    ChatMessageModel(id: '4', kontributorName: 'Moch Ilham Dwiky Fajar Al H.A', chatMessage: '[18:22] : Jalur tol sby-malang ada laka bruntun 3 unit yg mau masuk gerbang tol japanan, arah sby', status: true, tanggalPosting: DateTime(2024, 6, 18, 18, 22, 55)),
    ChatMessageModel(id: '5', kontributorName: 'Heriawan Chandra Saputra', chatMessage: '[18:01] : Air PDAM Delta Tirta Sidoarjo sering mati di daerah perum citra fajar golf', status: true, tanggalPosting: DateTime(2024, 6, 18, 18, 1, 15)),
    ChatMessageModel(id: '6', kontributorName: 'muhamad tresno gusti', chatMessage: '[13:33] : pukul 13.31 surabaya-malang jalur bawah ramai lancar', status: true, tanggalPosting: DateTime(2024, 6, 18, 13, 33, 8)),
    ChatMessageModel(id: '7', kontributorName: 'jason ezekiel', chatMessage: '[22:37] : tolong berhati-hati dijalan, baru saja mobil saya jd korban, banyak supporter diluar kendali, tidak berpendidikan, merugikan pihak" tidak bersalah', status: true, tanggalPosting: DateTime(2024, 6, 17, 22, 37, 9)),
  ];

  late List<ChatMessageModel> _filteredData;
  String _searchTerm = "";
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd\nHH:mm:ss');

  @override
  void initState() {
    super.initState();
    _filteredData = _chatData;
    // Set locale untuk timeago ke bahasa Indonesia
    timeago.setLocaleMessages('id', timeago.IdMessages());
  }

  void _filterData(String query) {
    setState(() {
      _searchTerm = query;
      if (query.isEmpty) {
        _filteredData = _chatData;
      } else {
        _filteredData = _chatData
            .where((item) =>
                item.kontributorName.toLowerCase().contains(query.toLowerCase()) ||
                item.chatMessage.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey('chatManagementPage'),
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
              'Chat Management',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Halaman untuk Chat di CMS',
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
            Text('Chat Management', style: TextStyle(color: AppColors.foreground)),
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
        DataColumn(label: Text('Kontributor')),
        DataColumn(label: Text('Chat')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Jenis\nStatus')),
        DataColumn(label: Text('Waktu')),
        DataColumn(label: Text('Tanggal\nPosting')),
      ],
      rows: _filteredData.map((item) {
        // Menghitung waktu relatif dari sekarang
        final String timeAgo = timeago.format(item.tanggalPosting, locale: 'id');

        return DataRow(cells: [
          DataCell(
            Text(item.kontributorName, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
          ),
          DataCell(
            SizedBox(
              width: 450, // Beri lebar untuk teks chat
              child: Text(item.chatMessage, maxLines: 3, overflow: TextOverflow.ellipsis),
            ),
          ),
          DataCell(
            Icon(
              item.status ? Icons.check_circle : Icons.radio_button_unchecked,
              color: item.status ? AppColors.success : AppColors.foreground.withOpacity(0.5),
            ),
          ),
          DataCell(Text(item.status ? 'Aktif' : 'Tidak Aktif')),
          DataCell(Text(timeAgo)),
          DataCell(Text(_dateFormatter.format(item.tanggalPosting))),
        ]);
      }).toList(),
    );
  }
}