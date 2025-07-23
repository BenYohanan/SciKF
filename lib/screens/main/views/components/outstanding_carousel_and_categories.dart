import 'package:flutter/material.dart';
import 'package:news_feeds/model/innovation_model.dart';

import '../../../../components/skleton/others/categories_skelton.dart';
import '../../../../components/skleton/others/offers_skelton.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import 'categories.dart';
import 'outstanding_carousel.dart';

class OutstandingCarouselAndCategories extends StatelessWidget {
  OutstandingCarouselAndCategories({
    super.key,
    required this.outstandingInnovation,
  });
  List<InnovationModel>? outstandingInnovation = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutstandingCarousel(flashInnovations: outstandingInnovation!),
        SizedBox(height: getProportionateScreenHeight(8)),
        Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(16)),
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: getProportionateScreenHeight(16),
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
        ),
        const Categories(),
      ],
    );
  }
}
