import 'package:admin_dashboard_template/core/auth/auth_service.dart';
import 'package:admin_dashboard_template/core/theme/app_colors.dart';
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
  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    // In a real app, you'd fetch the full user profile
    _nameController = TextEditingController(text: "Admin User"); // Placeholder
    _emailController = TextEditingController(text: authService.userEmail ?? "admin@example.com");
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

  void _saveProfileInfo() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Simulate API call to save profile info
      print("Saving profile: Name: ${_nameController.text}, Email: ${_emailController.text}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile information updated!'), backgroundColor: Colors.green),
      );
      setState(() => _isEditingInfo = false);
    }
  }

  void _changePassword() {
     if (_formKey.currentState!.validate()) {
      // Simulate API call to change password
      print("Changing password. New password: ${_newPasswordController.text}");
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!'), backgroundColor: Colors.green),
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() => _isChangingPassword = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authService = Provider.of<AuthService>(context);

    return ListView(
      key: const PageStorageKey('profilePage'),
      padding: const EdgeInsets.all(0),
      children: [
        Text('User Profile', style: textTheme.headlineMedium),
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
                      child: Text(
                        authService.userEmail?.substring(0, 1).toUpperCase() ?? "A",
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_nameController.text, style: textTheme.headlineSmall), // Display name
                        Text(authService.userEmail ?? '', style: textTheme.titleMedium?.copyWith(color: AppColors.primary)),
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
                Text('Personal Information', style: textTheme.titleLarge),
                const Divider(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  enabled: _isEditingInfo,
                  validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  enabled: _isEditingInfo,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Email cannot be empty';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                if (_isEditingInfo) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() {
                          _isEditingInfo = false;
                          // Reset fields if needed
                          _nameController.text = "Admin User"; // Placeholder
                          _emailController.text = authService.userEmail ?? "admin@example.com";
                        }),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _saveProfileInfo,
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 40),
                Text('Change Password', style: textTheme.titleLarge),
                const Divider(height: 20),

                if (!_isChangingPassword)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.lock_reset_outlined, size:18),
                      label: const Text('Change Password'),
                      onPressed: () => setState(() => _isChangingPassword = true),
                    ),
                  ),

                if (_isChangingPassword) ...[
                  TextFormField(
                    controller: _currentPasswordController,
                    decoration: const InputDecoration(labelText: 'Current Password'),
                    obscureText: true,
                     validator: (value) => value!.isEmpty ? 'Current password is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) return 'New password is required';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm New Password'),
                    obscureText: true,
                     validator: (value) {
                      if (value!.isEmpty) return 'Please confirm your new password';
                      if (value != _newPasswordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() {
                           _isChangingPassword = false;
                           _currentPasswordController.clear();
                           _newPasswordController.clear();
                           _confirmPasswordController.clear();
                        }),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _changePassword,
                        child: const Text('Update Password'),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}
