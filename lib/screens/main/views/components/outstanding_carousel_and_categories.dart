import 'package:flutter/material.dart';
import 'package:news_feeds/model/innovation_model.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import 'categories.dart';
import 'outstanding_carousel.dart';

class OutstandingCarouselAndCategories extends StatefulWidget {
  OutstandingCarouselAndCategories({
    super.key,
    required this.outstandingInnovation,
  });
  List<InnovationModel>? outstandingInnovation = [];

  @override
  State<OutstandingCarouselAndCategories> createState() => _OutstandingCarouselAndCategoriesState();
}

class _OutstandingCarouselAndCategoriesState extends State<OutstandingCarouselAndCategories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutstandingCarousel(flashInnovations: widget.outstandingInnovation!),
        SizedBox(height: getProportionateScreenHeight(8)),
        const Categories(),
      ],
    );
  }
}
