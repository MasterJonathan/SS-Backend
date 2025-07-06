

import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/settings_model.dart';
import 'package:admin_dashboard_template/providers/settings_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  
  
  final TextEditingController _audioUrlController = TextEditingController();
  final TextEditingController _visualUrlController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  
  
  bool _isChatActive = true;

  
  SettingsModel? _initialSettings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    if (settingsProvider.settings != null && _initialSettings == null) {
      _initialSettings = settingsProvider.settings;
      _loadSettingsToControllers(_initialSettings!);
    }
  }

  void _loadSettingsToControllers(SettingsModel settings) {
    _audioUrlController.text = settings.audioStreamingUrl;
    _visualUrlController.text = settings.visualRadioUrl;
    _termsController.text = settings.termsAndConditions;
    setState(() {
      _isChatActive = settings.isChatActive;
    });
  }

  @override
  void dispose() {
    _audioUrlController.dispose();
    _visualUrlController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  void _submitSettings() async {
    if (_formKey.currentState!.validate()) {
      final settingsProvider = context.read<SettingsProvider>();
      
      final newSettings = SettingsModel(
        audioStreamingUrl: _audioUrlController.text,
        visualRadioUrl: _visualUrlController.text,
        termsAndConditions: _termsController.text,
        isChatActive: _isChatActive,
      );

      final success = await settingsProvider.updateSettings(newSettings);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Pengaturan berhasil disimpan!' : 'Gagal menyimpan pengaturan.'),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {
        
        if (provider.settings != null && _initialSettings != provider.settings) {
          _initialSettings = provider.settings;
          _loadSettingsToControllers(_initialSettings!);
        }
        
        return SingleChildScrollView(
          key: const PageStorageKey('settingsPage'),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              if (provider.state == SettingsViewState.Busy && provider.settings == null)
                const Center(child: CircularProgressIndicator())
              else if (provider.errorMessage != null && provider.settings == null)
                Center(child: Text('Error: ${provider.errorMessage}'))
              else
                CustomCard(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(label: 'Audio Streaming URL', controller: _audioUrlController),
                        const SizedBox(height: 20),
                        _buildTextField(label: 'Visual Radio URL', controller: _visualUrlController),
                        const SizedBox(height: 20),
                        Text('Term and Conditions', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _termsController,
                          maxLines: 15,
                          minLines: 10,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(hintText: 'Enter terms and conditions here...', alignLabelWithHint: true),
                        ),
                        const SizedBox(height: 20),
                        _buildCheckbox(),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            onPressed: provider.state == SettingsViewState.Busy ? null : _submitSettings,
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                            child: provider.state == SettingsViewState.Busy 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                                : const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Website Setting', style: Theme.of(context).textTheme.headlineSmall),
        Row(
          children: [
            const Icon(Icons.home, color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Text('Home', style: TextStyle(color: AppColors.primary)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: AppColors.foreground.withOpacity(0.5), size: 18),
            const SizedBox(width: 4),
            Text('Website Setting', style: TextStyle(color: AppColors.foreground)),
          ],
        )
      ],
    );
  }
  
  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
        ),
      ],
    );
  }
  
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
          onTap: () => setState(() => _isChatActive = !_isChatActive),
          child: Text('Chat Aktif ?', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}