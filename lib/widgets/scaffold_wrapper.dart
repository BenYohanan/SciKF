import 'package:flutter/material.dart';
import '../../size_config.dart';
import '../../constants.dart';

class ScaffoldWrapper extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const ScaffoldWrapper({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          body,
          Positioned(
            bottom: getProportionateScreenHeight(10),
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Funded by TETFund',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(12),
                  color: textColor.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}