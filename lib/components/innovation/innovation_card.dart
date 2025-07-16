import 'package:flutter/material.dart';
import 'package:news_feeds/size_config.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class InnovationCard extends StatelessWidget {
  const InnovationCard({
    super.key,
    required this.image,
    required this.author,
    required this.title,
    required this.category,
    required this.press,
  });
  final String image, author, title, category;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(140, 220),
          maximumSize: const Size(140, 220),
          padding: const EdgeInsets.all(8)),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 0.7,
            child: Stack(
              children: [
                NetworkImageWithLoader(image, radius: defaultBorderRadious),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(8)),
                  Text(
                    author.toUpperCase(),
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(10),
                      fontWeight: FontWeight.bold,
                      color: primaryColor.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(8)),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(10),
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(8)),
                  Text(
                      category,
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(10),
                      fontWeight: FontWeight.bold,
                      color: primaryColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
