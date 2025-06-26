import 'package:flutter/material.dart';

class ProfileDetailsCard extends StatelessWidget{
  const ProfileDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profil Kontributor',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            _buildInfoTile(
              icon: Icons.location_on_outlined,
              label: 'Lokasi',
              value: 'Sidoarjo',
              iconColor: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            _buildInfoTile(
              icon: Icons.phone_outlined,
              label: 'Telepon',
              value: '0812-XXXX-XXXX',
              iconColor: Colors.blue.shade400,
            ),
            const SizedBox(height: 16),
            _buildInfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'sugeng.p@email.com',
              iconColor: Colors.green.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }
}