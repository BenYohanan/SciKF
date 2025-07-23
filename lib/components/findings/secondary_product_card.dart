import 'package:flutter/material.dart';
import 'package:news_feeds/size_config.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class SecondaryFindingsCard extends StatelessWidget {
  const SecondaryFindingsCard({
    super.key,
    required this.image,
    required this.category,
    required this.title,
    this.date,
    this.status,
  });

  final String image, category, title;
  final String? date, status;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: getProportionateScreenHeight(90)),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                NetworkImageWithLoader(image, radius: defaultBorderRadious),
              ],
            ),
          ),
          SizedBox(width: getProportionateScreenHeight(8)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenHeight(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: getProportionateScreenHeight(12)),
                  ),
                  SizedBox(height: getProportionateScreenHeight(8)),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 14),
                  ),
                  SizedBox(height: getProportionateScreenHeight(8)),
                  Row(
                    children: [
                      Text(
                        status ?? 'N/A',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: defaultPadding / 4),
                      Text(
                        date ?? 'N/A',
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: getProportionateScreenHeight(10),
                        ),
                      ),
                    ],
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