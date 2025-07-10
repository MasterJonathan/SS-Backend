import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/widgets/contributor/activity_feed_panel.dart';
import 'package:admin_dashboard_template/widgets/contributor/profile_details_card.dart';
import 'package:admin_dashboard_template/widgets/contributor/profile_summary_card.dart';
import 'package:flutter/material.dart';

class ContributorPage extends StatelessWidget {
  const ContributorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _buildWideLayout();
          } else {
            return _buildNarrowLayout();
          }
        },
      ),
      backgroundColor: AppColors.surface,
    );
  }

  
  Widget _buildWideLayout() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 280,
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  ProfileSummaryCard(),
                  SizedBox(height: 16),
                  ProfileDetailsCard(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: ActivityFeedPanel(),
          ),
        ],
      ),
    );
  }

  
  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            const ProfileSummaryCard(),
            const SizedBox(height: 16),
            const ProfileDetailsCard(),
            const SizedBox(height: 16),
            const ActivityFeedPanel(isExternallyScrolled: true),
          ],
        ),
      ),
    );
  }
}