import 'package:flutter/material.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../components/innovation/innovation_card.dart';
import '../../../../constants.dart';
import '../../../../model/innovation_model.dart';
import '../../../innovation/views/innovation_details_screen.dart';

class RecentInnovations extends StatefulWidget {
  RecentInnovations({
    super.key,
    required this.recentInnovations,
  });
  List<InnovationModel> recentInnovations = [];

  @override
  State<RecentInnovations> createState() => _RecentInnovationsState();
}

class _RecentInnovationsState extends State<RecentInnovations> {
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
              color: textColor,
            ),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(270),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.recentInnovations.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == widget.recentInnovations.length - 1
                    ? getProportionateScreenHeight(16)
                    : 0,
              ),
              child: InnovationCard(
                image: widget.recentInnovations[index].image,
                author: widget.recentInnovations[index].author,
                title: widget.recentInnovations[index].title,
                category: widget.recentInnovations[index].category,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InnovationDetailsScreen(innovationModel: widget.recentInnovations[index]),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
