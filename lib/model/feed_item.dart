import 'dart:ui';

import 'package:flutter/material.dart';

class FeedItem {
  final String title;
  final String timeAgo;
  final Color circleColor;
  final IconData icon;

  FeedItem({
    required this.title,
    required this.timeAgo,
    required this.circleColor,
    required this.icon,
  });
}