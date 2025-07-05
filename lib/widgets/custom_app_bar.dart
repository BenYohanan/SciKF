import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';

import '../size_config.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    required this.fullName,
    required this.isOnline,
  });

  final String fullName;
  final bool isOnline;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[100],
      leading: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
        },
        child: Image.asset(
          'assets/img/icon.png',
          width: getProportionateScreenWidth(70),
          height: getProportionateScreenHeight(40),
        ),
      ),
      title: Row(
        children: [
          Text(
            'SciKF',
            style: TextStyle(
              fontSize: getProportionateScreenHeight(20),
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}