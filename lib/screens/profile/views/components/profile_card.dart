import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../components/network_image_with_loader.dart';
import '../../../../constants.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageSrc,
    this.press
  });

  final String name, email, imageSrc;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: CircleAvatar(
        radius: getProportionateScreenHeight(30),
        child: NetworkImageWithLoader(
          imageSrc,
          radius: 100,
        ),
      ),
      title: Row(
        children: [
          Text(
            "Hi, $name",
            style: TextStyle(fontWeight: FontWeight.w700, color: primaryColor, fontSize: getProportionateScreenHeight(16)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: defaultPadding / 2),
        ],
      ),
      subtitle: Text(email),
      trailing: SvgPicture.asset(
              "assets/icons/miniRight.svg",
              color: primaryColor,
            )
    );
  }
}
