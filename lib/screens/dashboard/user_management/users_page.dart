// lib/screens/dashboard/users_page.dart

import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/user_model.dart';
import 'package:admin_dashboard_template/providers/user_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UsersAdminPage extends StatefulWidget {
  const UsersAdminPage({super.key});

  @override
  State<UsersAdminPage> createState() => _UsersAdminPageState();
}

class _UsersAdminPageState extends State<UsersAdminPage> {
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd HH:mm');

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

  // Dialog tidak banyak berubah, hanya memastikan field 'isActive' ditangani saat update
  void _showAddEditDialog({UserModel? user}) {
    final isEditing = user != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user?.nama);
    final emailController = TextEditingController(text: user?.email);
    String selectedRole = user?.role ?? 'User';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit User' : 'Tambah User'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama'), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email'), enabled: !isEditing, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: ['User', 'Admin', 'Editor', 'Moderator'].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                    onChanged: (value) { if (value != null) { selectedRole = value; } },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final provider = context.read<UserProvider>();
                  if (isEditing) {
                    // Membuat salinan user yang ada dengan data baru
                    final Map<String, dynamic> updatedData = {
                      'nama': nameController.text,
                      'role': selectedRole,
                    };

                    // Panggil metode update parsial (akan kita buat di provider & service)
                    await provider.updateUserPartial(user.id, updatedData);

                  } else {
                    print("Penambahan user baru seharusnya melalui halaman registrasi.");
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        List<UserModel> filteredData;
        final query = _searchController.text.toLowerCase();
        
        if (query.isEmpty) {
          filteredData = provider.users;
        } else {
          filteredData = provider.users.where((user) =>
            user.nama.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            user.role.toLowerCase().contains(query)
          ).toList();
        }

        return CustomCard(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('User Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(labelText: 'Search...', prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (provider.state == UserViewState.Busy)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (provider.errorMessage != null)
                Expanded(child: Center(child: Text('Error: ${provider.errorMessage}')))
              else
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Role')),
                          DataColumn(label: Text('Tgl Registrasi')), // ✨ KOLOM BARU
                          DataColumn(label: Text('Status')),       // ✨ KOLOM BARU
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: filteredData.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user.nama)),
                              DataCell(Text(user.email)),
                              DataCell(
                                Chip(
                                  label: Text(user.role),
                                  backgroundColor: AppColors.primary.withOpacity(0.1),
                                  labelStyle: TextStyle(color: AppColors.primary),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                ),
                              ),
                              // ✨ DATA CELL BARU
                              DataCell(Text(user.waktu != null ? _dateFormatter.format(user.waktu!) : '-')),
                              DataCell(
                                Chip(
                                  label: Text(user.isActive ? 'Active' : 'Inactive'),
                                  backgroundColor: user.isActive ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                                  labelStyle: TextStyle(color: user.isActive ? AppColors.success : AppColors.error),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: AppColors.primary),
                                      tooltip: 'Edit User',
                                      onPressed: () => _showAddEditDialog(user: user),
                                    ),
                                    // ✨ TOMBOL DISABLE/ENABLE BARU
                                    IconButton(
                                      icon: Icon(
                                        user.isActive ? Icons.block : Icons.power_settings_new,
                                        color: user.isActive ? AppColors.error : AppColors.success,
                                      ),
                                      tooltip: user.isActive ? 'Nonaktifkan User' : 'Aktifkan User',
                                      onPressed: () async {
                                        final newStatus = !user.isActive;
                                        await context.read<UserProvider>().updateUserPartial(
                                          user.id,
                                          {'isActive': newStatus},
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}