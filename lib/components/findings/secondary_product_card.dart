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
    required this.author,
    this.date,
    this.status,
    this.authorEmail
  });

  final String image, category, title, author;
  final String? date, status, authorEmail;

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
                image.isEmpty
                    ? Image.asset('assets/img/NoImg.png',fit: BoxFit.cover,
                )
                    : NetworkImageWithLoader(
                  image,
                  radius: defaultBorderRadious,
                )
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
                    title.toUpperCase(),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: getProportionateScreenHeight(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(2)),
                  Text(
                    category.isEmpty ? "":
                    "Category: $category",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 14),
                  ),
                  SizedBox(height: getProportionateScreenHeight(2)),
                  Text(
                    author.isEmpty ? "":
                    "Author: $author",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 10),
                  ),
                  SizedBox(height: getProportionateScreenHeight(2)),
                  Text(
                    authorEmail == null ? "":
                    "Author Email: $authorEmail",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: getProportionateScreenHeight(10),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(2)),
                  Row(
                    children: [
                      Text(
                        status ?? '',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: defaultPadding / 4),
                      Text(
                        date ?? '',
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