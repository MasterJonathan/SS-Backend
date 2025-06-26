import 'package:flutter/material.dart';

enum ActivityType { post, like, comment }

class ActivityModel {
  final IconData icon;
  final Color iconColor;
  final String description;
  final String timeAgo;

  ActivityModel({
    required this.icon,
    required this.iconColor,
    required this.description,
    required this.timeAgo,
  });
}