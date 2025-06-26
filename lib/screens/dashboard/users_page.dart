import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CombinedUserModel {
  final String id;
  final String username;
  final List<String> hakAkses;
  final String role;
  final bool status;
  final bool administrator;
  final DateTime tanggalPosting;
  final String dipostingOleh;

  CombinedUserModel({
    required this.id,
    required this.username,
    required this.hakAkses,
    required this.role,
    required this.status,
    required this.administrator,
    required this.tanggalPosting,
    required this.dipostingOleh,
  });

  CombinedUserModel copyWith({
    String? id,
    String? username,
    List<String>? hakAkses,
    String? role,
    bool? status,
    bool? administrator,
    DateTime? tanggalPosting,
    String? dipostingOleh,
  }) {
    return CombinedUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      hakAkses: hakAkses ?? this.hakAkses,
      role: role ?? this.role,
      status: status ?? this.status,
      administrator: administrator ?? this.administrator,
      tanggalPosting: tanggalPosting ?? this.tanggalPosting,
      dipostingOleh: dipostingOleh ?? this.dipostingOleh,
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final List<CombinedUserModel> _users = List.generate(
    20,
    (index) => CombinedUserModel(
      id: '${index + 1}',
      username: 'user${index + 1}',
      hakAkses:
          (index % 3 == 0)
              ? [
                'Setting Management',
                'User Management',
                'Page Management',
                'Kawan SS Management',
                'Report Management',
                'Berita Web',
                'Kontributor',
                'Video/Audio Call',
                'Chat Management',
              ]
              : (index % 3 == 1)
              ? [
                'Setting Management',
                'User Management',
                'Page Management',
                'Berita Web',
                'Management',
                'Kontributor',
              ]
              : [
                'Setting Management',
                'User Management',
                'Page Management',
                'Kawan SS Management',
                'Report Management',
              ],
      role: (index % 2 == 0) ? 'Editor' : 'Moderator',
      status: index % 2 == 0,
      administrator: index % 3 == 0,
      tanggalPosting: DateTime(2023, 1, 15 + index, 10, 30 + index),
      dipostingOleh: 'admin_ss',
    ),
  );

  late List<CombinedUserModel> _filteredUsers;
  String _searchTerm = "";
  final DateFormat _displayDateFormatter = DateFormat(
    'EEEE, dd MMMM yyyy',
    'id_ID',
  );
  final DateFormat _displayTimeFormatter = DateFormat('HH:mm:ss', 'id_ID');

  @override
  void initState() {
    super.initState();
    _filteredUsers = _users;
  }

  void _filterUsers(String query) {
    setState(() {
      _searchTerm = query;
      if (query.isEmpty) {
        _filteredUsers = _users;
      } else {
        _filteredUsers =
            _users
                .where(
                  (user) =>
                      user.username.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      user.dipostingOleh.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  void _showEditUserDialog({CombinedUserModel? user}) {
    final isEditing = user != null;
    final _formKeyDialog =
        GlobalKey<FormState>(); // Different key for dialog form

    String tempUsername = user?.username ?? '';
    String tempSelectedRole = user?.role ?? 'Editor'; // Default role
    bool tempStatus = user?.status ?? true;
    bool tempAdministrator = user?.administrator ?? false;
    String tempDipostingOleh = user?.dipostingOleh ?? '';
    List<String> tempHakAkses = List<String>.from(
      user?.hakAkses ?? ['Default Access'],
    ); // Editable copy

    final List<String> availableRoles = [
      'Editor',
      'Moderator',
      'Viewer',
      'Admin',
    ]; // Example roles

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // Make the dialog wider by wrapping it in a Container with a specific width.
          // We use a Builder to get a new context that knows the size of the parent.
          content: Builder(
            builder: (context) {
              // Get the screen width
              var width = MediaQuery.of(context).size.width;
              return SizedBox(
                width:
                    width *
                    0.4, // Use 80% of the screen width, you can adjust this
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKeyDialog,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 16), // Adds vertical spacing
                        TextFormField(
                          initialValue: tempUsername,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                          onSaved: (value) => tempUsername = value!,
                        ),
                        const SizedBox(height: 16), // Adds vertical spacing
                        DropdownButtonFormField<String>(
                          value: tempSelectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Role (Jenis User)',
                          ),
                          items:
                              availableRoles.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              // You might want to use setState here if the dialog's state needs to react immediately
                              tempSelectedRole = newValue;
                            }
                          },
                          onSaved:
                              (value) =>
                                  tempSelectedRole = value ?? tempSelectedRole,
                          validator:
                              (value) =>
                                  value == null ? 'Please select a role' : null,
                        ),
                        // Hak Akses - simplified display
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Hak Akses: ${tempHakAkses.join(', ')}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        StatefulBuilder(
                          // To manage checkbox state within the dialog
                          builder: (
                            BuildContext context,
                            StateSetter setStateDialog,
                          ) {
                            return Column(
                              children: [
                                CheckboxListTile(
                                  title: const Text('Status Active'),
                                  value: tempStatus,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      setStateDialog(() {
                                        tempStatus = value;
                                      });
                                    }
                                  },
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                // No extra SizedBox needed here as CheckboxListTile has padding
                                CheckboxListTile(
                                  title: const Text('Administrator'),
                                  value: tempAdministrator,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      setStateDialog(() {
                                        tempAdministrator = value;
                                      });
                                    }
                                  },
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8), // Adds vertical spacing
                        TextFormField(
                          initialValue: tempDipostingOleh,
                          decoration: const InputDecoration(
                            labelText: 'Diposting Oleh',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) => tempDipostingOleh = value!,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(isEditing ? 'Save Changes' : 'Add User'),
              onPressed: () {
                if (_formKeyDialog.currentState!.validate()) {
                  _formKeyDialog.currentState!.save();
                  final now = DateTime.now();
                  final processedUser = CombinedUserModel(
                    id:
                        isEditing
                            ? user.id
                            : DateTime.now().millisecondsSinceEpoch.toString(),
                    username: tempUsername,
                    hakAkses: tempHakAkses,
                    role: tempSelectedRole,
                    status: tempStatus,
                    administrator: tempAdministrator,
                    tanggalPosting: isEditing ? user.tanggalPosting : now,
                    dipostingOleh: tempDipostingOleh,
                  );

                  setState(() {
                    // This setState is for the _UsersPageState
                    if (isEditing) {
                      final index = _users.indexWhere((u) => u.id == user.id);
                      if (index != -1) {
                        _users[index] = processedUser;
                      }
                    } else {
                      _users.insert(0, processedUser);
                    }
                    _filterUsers(_searchTerm);
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing
                            ? 'User updated successfully!'
                            : 'User added successfully!',
                      ),
                      backgroundColor: Colors.green, // Example success color
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(CombinedUserModel user) {
    print("Delete user: ${user.username}");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete user ${user.username}?",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: AppColors.foreground),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text("Delete"),
              onPressed: () {
                setState(() {
                  _users.removeWhere((u) => u.id == user.id);
                  _filterUsers(_searchTerm);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${user.username} deleted successfully."),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'editor':
        return Colors.green.shade100;
      case 'moderator':
        return Colors.orange.shade100;
      default:
        return Colors.blue.shade100;
    }
  }

  Color _getRoleTextColor(String role) {
    switch (role.toLowerCase()) {
      case 'editor':
        return Colors.green.shade900;
      case 'moderator':
        return Colors.orange.shade900;
      default:
        return Colors.blue.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Color primaryColor = AppColors.primary;
    final Color onPrimaryColor = AppColors.surface;
    final Color errorColor = AppColors.error;

    return CustomCard(
      key: const PageStorageKey('usersPage'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: AppColors.foreground),
                  decoration: InputDecoration(
                    labelText: 'Search Users (by username or posted by)',
                    labelStyle: TextStyle(
                      color: AppColors.foreground.withOpacity(0.7),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.foreground.withOpacity(0.7),
                    ),
                  ),
                  onChanged: _filterUsers,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: onPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add User'),
                onPressed: () => _showEditUserDialog(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder(),
                  columnSpacing: 20,
                  headingRowHeight: 48,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 180,
                  columns: const [
                    DataColumn(label: Text('Username')),
                    DataColumn(label: Text('Hak Akses')),
                    DataColumn(label: Text('Jenis User')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Administrator')),
                    DataColumn(label: Text('Tanggal Posting')),
                    DataColumn(label: Text('Diposting Oleh')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows:
                      _filteredUsers.map((user) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                user.username,
                                style: TextStyle(color: AppColors.foreground),
                              ),
                            ),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    user.hakAkses
                                        .map(
                                          (hak) => Text(
                                            '• $hak',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.foreground
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                            DataCell(
                              Chip(
                                label: Text(user.role),
                                backgroundColor: _getRoleColor(user.role),
                                labelStyle: TextStyle(
                                  color: _getRoleTextColor(user.role),
                                  fontWeight: FontWeight.w500,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Chip(
                                label: Text(
                                  user.status ? "Active" : "Inactive",
                                ),
                                backgroundColor:
                                    user.status
                                        ? AppColors.success
                                        : AppColors.error,
                                labelStyle: TextStyle(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w500,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Chip(
                                label: Text(
                                  user.administrator ? "Admin" : "User",
                                ),
                                backgroundColor:
                                    user.administrator
                                        ? AppColors.success
                                        : AppColors.warning,
                                labelStyle: TextStyle(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w500,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _displayDateFormatter.format(
                                      user.tanggalPosting,
                                    ),
                                    style: TextStyle(
                                      color: AppColors.foreground,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _displayTimeFormatter.format(
                                      user.tanggalPosting,
                                    ),
                                    style: TextStyle(
                                      color: AppColors.foreground.withOpacity(
                                        0.75,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                user.dipostingOleh,
                                style: TextStyle(color: AppColors.foreground),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.primary,
                                    ),
                                    tooltip: "Edit User",
                                    onPressed:
                                        () => _showEditUserDialog(user: user),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: errorColor,
                                    ),
                                    tooltip: "Delete User",
                                    onPressed: () => _deleteUser(user),
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
          if (_filteredUsers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "No users found matching your search.",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.foreground,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
