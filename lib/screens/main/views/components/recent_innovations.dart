import 'package:flutter/material.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../components/innovation/innovation_card.dart';
import '../../../../components/skleton/innovation/products_skelton.dart';
import '../../../../constants.dart';
import '../../../../model/innovation_model.dart';
import '../../../../route/route_constants.dart';

class RecentInnovations extends StatelessWidget {
  RecentInnovations({
    super.key,
    required this.recentInnovation,
    required this.isLoading
  });
  List<InnovationModel>? recentInnovation = [];
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: getProportionateScreenHeight(20)),
        Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(16)),
          child: Text(
            "Top Picks",
            style: TextStyle(
              fontSize: getProportionateScreenHeight(12),
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
        ),
        isLoading ? const ProductsSkelton() :
        SizedBox(
          height: getProportionateScreenHeight(270),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentInnovations.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == recentInnovations.length - 1
                    ? getProportionateScreenHeight(16)
                    : 0,
              ),
              child: InnovationCard(
                image: recentInnovations[index].image,
                author: recentInnovations[index].author,
                title: recentInnovations[index].title,
                category: recentInnovations[index].category,
                press: () {
                  Navigator.pushNamed(context, productDetailsScreenRoute,
                      arguments: index.isEven);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
