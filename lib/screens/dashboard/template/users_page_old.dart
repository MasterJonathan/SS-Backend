import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/models/user_admin_model.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // Mock data - in a real app, this would come from a service/API
  final List<UserAdminModel> _users = [
    UserAdminModel(
      id: '1',
      name: 'Alice Smith',
      email: 'alice@example.com',
      role: 'Admin',
      joinedDate: DateTime(2023, 1, 15),
    ),
    UserAdminModel(
      id: '2',
      name: 'Bob Johnson',
      email: 'bob@example.com',
      role: 'Editor',
      joinedDate: DateTime(2023, 2, 20),
    ),
    UserAdminModel(
      id: '3',
      name: 'Charlie Brown',
      email: 'charlie@example.com',
      role: 'Viewer',
      joinedDate: DateTime(2023, 3, 10),
    ),
    UserAdminModel(
      id: '4',
      name: 'Diana Prince',
      email: 'diana@example.com',
      role: 'Editor',
      joinedDate: DateTime(2023, 4, 5),
    ),
  ];
  List<UserAdminModel> _filteredUsers = [];
  String _searchTerm = "";
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

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
                      user.name.toLowerCase().contains(query.toLowerCase()) ||
                      user.email.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void _showEditUserDialog({UserAdminModel? user}) {
    final isEditing = user != null;
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    String selectedRole = user?.role ?? 'Viewer'; // Default role
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit User' : 'Add New User'),
          content: SingleChildScrollView(
            // In case of many fields
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Name cannot be empty' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Email cannot be empty';
                      if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items:
                        ['Admin', 'Editor', 'Viewer']
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) selectedRole = value;
                    },
                    validator:
                        (value) =>
                            value == null ? 'Please select a role' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text(isEditing ? 'Save Changes' : 'Add User'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    if (isEditing) {
                      final index = _users.indexWhere((u) => u.id == user.id);
                      if (index != -1) {
                        _users[index] = user.copyWith(
                          name: nameController.text,
                          email: emailController.text,
                          role: selectedRole,
                        );
                      }
                    } else {
                      _users.add(
                        UserAdminModel(
                          id:
                              DateTime.now().millisecondsSinceEpoch
                                  .toString(), // Simple unique ID
                          name: nameController.text,
                          email: emailController.text,
                          role: selectedRole,
                          joinedDate: DateTime.now(),
                        ),
                      );
                    }
                    _filterUsers(_searchTerm); // Re-apply filter
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(UserAdminModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete user ${user.name}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text("Delete"),
              onPressed: () {
                setState(() {
                  _users.removeWhere((u) => u.id == user.id);
                  _filterUsers(_searchTerm);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${user.name} deleted successfully."),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomCard(
      key: const PageStorageKey('usersPage'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Users (by name or email)',
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _filterUsers,
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(16, 24, 20, 24),
                ),
                icon: const Icon(
                  Icons.add,
                  size: 16,
                ), // Ensure this size visually matches the text
                label: const Text('Add User'),
                onPressed: () => _showEditUserDialog(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              // Make table scrollable if content overflows
              child: SizedBox(
                // Ensures DataTable takes available width
                width: double.infinity,
                child: DataTable(
                  border: TableBorder(borderRadius: BorderRadius.circular(8)),
                  columnSpacing: 20,
                  headingRowHeight: 48,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 56,
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Joined Date')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows:
                      _filteredUsers.map((user) {
                        return DataRow(
                          cells: [
                            DataCell(Text(user.id)),
                            DataCell(Text(user.name)),
                            DataCell(Text(user.email)),
                            DataCell(
                              Chip(
                                label: Text(user.role),
                                backgroundColor:
                                    user.role == 'Admin'
                                        ? Colors.blue.shade100
                                        : (user.role == 'Editor'
                                            ? Colors.green.shade100
                                            : Colors.orange.shade100),
                                labelStyle: TextStyle(
                                  color:
                                      user.role == 'Admin'
                                          ? Colors.blue.shade900
                                          : (user.role == 'Editor'
                                              ? Colors.green.shade900
                                              : Colors.orange.shade900),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(_dateFormatter.format(user.joinedDate)),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.blue,
                                    ),
                                    tooltip: "Edit User",
                                    onPressed:
                                        () => _showEditUserDialog(user: user),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color:
                                          Theme.of(context).colorScheme.error,
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
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
