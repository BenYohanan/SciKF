import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../constants.dart';

class CategoryModel {
  final String name;
  final String? svgSrc;

  CategoryModel({
    required this.name,
    this.svgSrc,
  });
}

final List<CategoryModel> categories = [
  CategoryModel(name: "Health Care", svgSrc: "assets/icons/Health.svg"),
  CategoryModel(name: "Agriculture", svgSrc: "assets/icons/Agriculture.svg"),
  CategoryModel(name: "Env. Science", svgSrc: "assets/icons/Environmental.svg"),
];

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(4)),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Explore innovations across these areas",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(12)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: categories.map((item) {
              return _CategoryChip(
                category: item.name,
                svgSrc: item.svgSrc,
              );
            }).toList(),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(7)),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    this.svgSrc,
  });

  final String category;
  final String? svgSrc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (svgSrc != null)
            SvgPicture.asset(
              svgSrc!,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.srcIn,
              ),
            ),
          if (svgSrc != null) const SizedBox(width: 6),
          Text(
            category,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}