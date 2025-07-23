import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../constants.dart';

class CategoryModel {
  final String name;
  final String? svgSrc, route;

  CategoryModel({
    required this.name,
    this.svgSrc,
    this.route,
  });
}

List<CategoryModel> categories = [
  CategoryModel(name: "All Categories"),
  CategoryModel(name: "Health Care",svgSrc: "assets/icons/Health.svg"),
  CategoryModel(name: "Agriculture", svgSrc: "assets/icons/Agriculture.svg"),
  CategoryModel(name: "Environmental Science", svgSrc: "assets/icons/Environmental.svg")
];

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            categories.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? getProportionateScreenHeight(16) : getProportionateScreenHeight(8),
                  right:
                      index == categories.length - 1 ? getProportionateScreenHeight(16) : 0),
              child: CategoryBtn(
                category: categories[index].name,
                svgSrc: categories[index].svgSrc,
                isActive: index == 0,
                press: () {
                  if (categories[index].route != null) {
                    Navigator.pushNamed(context, categories[index].route!);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenHeight(30))),
      child: Container(
        height: getProportionateScreenHeight(36),
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(16)),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            if (svgSrc != null)
              SvgPicture.asset(
                svgSrc!,
                height: getProportionateScreenHeight(20),
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            if (svgSrc != null) SizedBox(width: getProportionateScreenWidth(8)),
            Text(
              category,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(12),
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
