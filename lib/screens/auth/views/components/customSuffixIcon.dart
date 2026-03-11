import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../size_config.dart';

class CustomSuffixIcon extends StatelessWidget {
  CustomSuffixIcon({
    super.key,
    required this.svgIcon,
    this.color,
  });
  final String svgIcon;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: getProportionateScreenWidth(18),
        color: color,
      ),
    );
  }
}
