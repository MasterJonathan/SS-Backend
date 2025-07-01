import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State for the checkbox
  bool _isChatActive = true;
  
  // Controllers for text fields
  final TextEditingController _audioUrlController = TextEditingController();
  final TextEditingController _visualUrlController = TextEditingController();
  // Controller for the multiline text field for Term and Conditions
  final TextEditingController _termsController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Set initial values for the form fields
    _audioUrlController.text = 'https://c5.siar.us:8000/stream';
    _visualUrlController.text = 'https://ssfm.siar.us/ssfm/live/playlist.m3u8';
    // Set initial text for the Term and Conditions
    _termsController.text = '''SYARAT DAN KETENTUAN

SELAMAT DATANG DI APLIKASI SUARA SURABAYA MOBILE

Aplikasi Suara Surabaya Mobile adalah sebuah produk media yang menampung informasi yang diperoleh dari berbagai unggahan/kontribusi/informasi netter, informasi pendengar radio atau yang lainnya yang telah diseleksi tim redaksi. Dalam aplikasi pengguna yang registrasi diberi kebebasan untuk mengemukakan, mengekspresikan, serta menyampaikan informasi, gagasan, pendapat, ulasan, ataupun tanggapan, sepanjang dapat dipertanggungjawabkan olehnya, sesuai dengan norma dan hukum yang berlaku di Indonesia.

Pengguna diharap/wajib membaca syarat dan ketentuan dengan teliti dan seksama serta terkait data personal atau informasi yang Anda berikan. Dengan menggunakan aplikasi Suara Surabaya Mobile, berarti Anda telah menyetujui syarat dan ketentuan yang berlaku.''';
  }

  @override
  void dispose() {
    _audioUrlController.dispose();
    _visualUrlController.dispose();
    _termsController.dispose(); // Also dispose this new controller
    super.dispose();
  }

  void _submitSettings() {
    // Logic to handle form submission
    final audioUrl = _audioUrlController.text;
    final visualUrl = _visualUrlController.text;
    final isChatActive = _isChatActive;
    final termsAndConditions = _termsController.text;
    
    print("Submitting Settings:");
    print("Audio URL: $audioUrl");
    print("Visual URL: $visualUrl");
    print("Chat Aktif: $isChatActive");
    print("Terms and Conditions: $termsAndConditions");

    // Here you would call your FirestoreService to save the data
    // e.g., firestoreService.updateWebsiteSettings(...);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings submitted successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey('settingsPage'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header and Breadcrumb
          _buildHeader(),
          const SizedBox(height: 24),

          // 2. Form content inside a CustomCard
          CustomCard(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Audio Streaming URL',
                  controller: _audioUrlController,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Visual Radio URL',
                  controller: _visualUrlController,
                ),
                const SizedBox(height: 20),

                // 3. Term and Conditions using a standard multiline TextFormField
                Text(
                  'Term and Conditions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _termsController,
                  // These properties make it a multiline text area
                  maxLines: 15, // Set a good number of lines to show
                  minLines: 10, // Minimum height it will occupy
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Enter terms and conditions here...',
                    // The main styling is handled by your app's overall InputDecorationTheme
                    // Align label to the top for multiline fields
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),

                // 4. Chat Aktif Checkbox
                _buildCheckbox(),
                const SizedBox(height: 24),

                // 5. Submit Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: _submitSettings,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the header section
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Website Setting',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        // Breadcrumb
        Row(
          children: [
            Icon(Icons.home, color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Text(
              'Home',
              style: TextStyle(color: AppColors.primary),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: AppColors.foreground.withOpacity(0.5), size: 18),
            const SizedBox(width: 4),
            Text(
              'Website Setting',
              style: TextStyle(color: AppColors.foreground),
            ),
          ],
        )
      ],
    );
  }
  
  // Helper widget for text fields to reduce repetition
  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
  
  // Helper widget for the checkbox
  Widget _buildCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _isChatActive,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() {
                  _isChatActive = value;
                });
              }
            },
            activeColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            setState(() {
              _isChatActive = !_isChatActive;
            });
          },
          child: Text(
            'Chat Aktif ?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}