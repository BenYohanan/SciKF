import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';

class InnovationInfo extends StatelessWidget {
  const InnovationInfo({
    super.key,
    required this.title,
    required this.author,
    required this.description
  });

  final String title, author, description;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              author.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              title,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Text(
              "Innovation info",
              style: TextStyle(
                fontSize: getProportionateScreenHeight(16),
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              description,
              style: const TextStyle(height: 1.4),
            ),
            const SizedBox(height: defaultPadding / 2),
          ],
        ),
      ),
    );
  }
}
