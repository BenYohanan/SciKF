import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../constants.dart';

class OnbordingContent extends StatelessWidget {
  const OnbordingContent({
    super.key,
    this.isTextOnTop = false,
    required this.title,
    required this.description,
    required this.icon,
  });

  final bool isTextOnTop;
  final String title, description, icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),

        if (isTextOnTop)
          OnbordTitleDescription(
            title: title,
            description: description,
          ),
        if (isTextOnTop) const Spacer(),
        SvgPicture.asset(
          icon,
          height: getProportionateScreenHeight(250),
          color: primaryColor,
        ),
        if (!isTextOnTop) const Spacer(),
        if (!isTextOnTop)
          OnbordTitleDescription(
            title: title,
            description:
            description,
          ),

        const Spacer(),
      ],
    );
  }
}

class OnbordTitleDescription extends StatelessWidget {
  const OnbordTitleDescription({
    super.key,
    required this.title,
    required this.description,
  });

  final String title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(24),
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
