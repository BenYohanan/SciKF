import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/size_config.dart';

import '../../constants.dart';
import 'banner_m.dart';

class BannerMStyle2 extends StatelessWidget {
  const BannerMStyle2({
    super.key,
    this.image,
    required this.title,
    required this.press,
    this.category,
  });
  final String? image,category;
  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return BannerM(
      image: image!,
      press: press,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: grandisExtendedFont,
                        fontSize: getProportionateScreenHeight(20),
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: defaultPadding / 4),
                    if (category != null)
                      Text(
                        category!.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenHeight(12),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: defaultPadding),
              SizedBox(
                height: 48,
                width: 48,
                child: ElevatedButton(
                  onPressed: press,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Arrow - Right.svg",
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
