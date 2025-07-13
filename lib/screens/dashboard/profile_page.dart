

import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/dashboard/user_management/user_model.dart';
import 'package:admin_dashboard_template/providers/auth/authentication_provider.dart'; 
import 'package:admin_dashboard_template/providers/dashboard/user_management/user_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEditingInfo = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    if (authProvider.user != null) {
      _nameController.text = authProvider.user!.nama;
      _emailController.text = authProvider.user!.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveProfileInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userProvider = context.read<UserProvider>();
      
      final authProvider = context.read<AuthenticationProvider>();

      if (authProvider.user != null) {
        final updatedUser = UserModel(
          id: authProvider.user!.id,
          nama: _nameController.text,
          username: authProvider.user!.username,
          status: authProvider.user!.status,
          joinDate: authProvider.user!.joinDate,
          email: authProvider.user!.email,
          role: authProvider.user!.role,
          photoURL: authProvider.user!.photoURL,
          jumlahComment: authProvider.user!.jumlahComment,
          jumlahKontributor: authProvider.user!.jumlahKontributor,
          jumlahLike: authProvider.user!.jumlahLike,
          jumlahShare: authProvider.user!.jumlahShare,
          
          // aktivitas: authProvider.user!.aktivitas,
          // namaAktivitas: authProvider.user!.namaAktivitas,
          alamat: authProvider.user!.alamat,
          jenisKelamin: authProvider.user!.jenisKelamin,
          nomorHp: authProvider.user!.nomorHp,
          tanggalLahir: authProvider.user!.tanggalLahir,
          // isActive: authProvider.user!.isActive
        );

        bool success = await userProvider.updateUser(updatedUser);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success ? 'Profil berhasil diperbarui!' : 'Gagal memperbarui profil.'),
              backgroundColor: success ? AppColors.success : AppColors.error,
            ),
          );
          if (success) {
            setState(() => _isEditingInfo = false);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          key: const PageStorageKey('profilePage'),
          padding: const EdgeInsets.all(0),
          children: [
            Text('User Profile', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            CustomCard(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primary,
                          backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                          child: user.photoURL == null
                              ? Text(
                                  user.nama.isNotEmpty ? user.nama[0].toUpperCase() : 'A',
                                  style: const TextStyle(fontSize: 30, color: Colors.white),
                                )
                              : null,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.nama, style: Theme.of(context).textTheme.headlineSmall),
                            Text(user.email, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.foreground.withOpacity(0.7))),
                          ],
                        ),
                        const Spacer(),
                        if (!_isEditingInfo)
                          TextButton.icon(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit Info'),
                            onPressed: () => setState(() => _isEditingInfo = true),
                          )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text('Personal Information', style: Theme.of(context).textTheme.titleLarge),
                    const Divider(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      enabled: _isEditingInfo,
                      validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email Address'),
                      enabled: false,
                    ),
                    if (_isEditingInfo) ...[
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditingInfo = false;
                                _nameController.text = user.nama;
                              });
                            },
                            child: const Text('Batal'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _saveProfileInfo,
                            child: const Text('Simpan Perubahan'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}