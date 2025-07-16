import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';
import 'categories.dart';
import 'outstanding_carousel.dart';

class OutstandingCarouselAndCategories extends StatelessWidget {
  const OutstandingCarouselAndCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // While loading use 👇
        // const OffersSkelton(),
        const OutstandingCarousel(),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: getProportionateScreenHeight(16),
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
        ),
        // While loading use 👇
        // const CategoriesSkelton(),
        const Categories(),
      ],
    );
  }
}
