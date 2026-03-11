import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';

class InnovationInfo extends StatelessWidget {
  const InnovationInfo({
    super.key,
    required this.title,
    required this.author,
    required this.description,
    required this.category
  });

  final String title, author, description, category;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(20),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(2)),
            Text(
              "Category: $category",
              style: TextStyle(
                fontSize: getProportionateScreenHeight(16),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(2)),
            Text(
              "Author: ${author.toUpperCase()}",
              style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            Text(
              description,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(16),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
