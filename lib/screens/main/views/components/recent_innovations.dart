import 'package:flutter/material.dart';
import 'package:news_feeds/route/route_constants.dart';
import 'package:news_feeds/services/storage_keys.dart';
import 'package:news_feeds/size_config.dart';
import '../../../../components/innovation/innovation_card.dart';
import '../../../../constants.dart';
import '../../../../model/innovation_model.dart';
import '../../../innovation/views/innovation_details_screen.dart';

class RecentInnovations extends StatelessWidget {
  const RecentInnovations({
    super.key,
    required this.recentInnovations,
  });

  final List<InnovationModel> recentInnovations;

  @override
  Widget build(BuildContext context) {
    if (recentInnovations.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(16)),
        child: Column(
          children: [
            _header(context),
            SizedBox(height: getProportionateScreenHeight(20)),
            Icon(Icons.auto_awesome,
                size: 60, color: Colors.grey.shade400),
            SizedBox(height: getProportionateScreenHeight(10)),
            const Text(
              "No innovations yet",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: getProportionateScreenHeight(20)),
        _header(context),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenHeight(16),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentInnovations.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final item = recentInnovations[index];

              return InnovationCard(
                image: item.image,
                author: item.author,
                title: item.title,
                category: item.category,
                displayType: item.displayType,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InnovationDetailsScreen(
                            innovationModel: item,
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Top Picks",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, approvedInnovationsScreenRoute);
            },
            child: Text(
              "See all",
              style: TextStyle(
                fontSize: 12,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}