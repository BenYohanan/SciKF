import 'package:flutter/material.dart';
import 'package:news_feeds/size_config.dart';
import '../../constants.dart';
import '../network_image_with_loader.dart';

class InnovationCard extends StatelessWidget {
  const InnovationCard({
    super.key,
    required this.image,
    required this.author,
    required this.title,
    required this.category,
    required this.press,
  });

  final String image;
  final String author;
  final String title;
  final String category;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: getProportionateScreenWidth(200),
        height: getProportionateScreenHeight(300),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 1),
          borderRadius: BorderRadius.circular(defaultBorderRadious),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(180),
              width: double.infinity,
              child: image.isEmpty
                  ? Image.asset('assets/img/NoImg.png', fit: BoxFit.cover)
                  : NetworkImageWithLoader(
                      image,
                      radius: defaultBorderRadious,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenHeight(16),
                top: getProportionateScreenHeight(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(10),
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(4)),
                  Text(
                    "Author: ${author.toUpperCase()}",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(10),
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: getProportionateScreenHeight(4)),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(10),
                      fontWeight: FontWeight.bold,
                      color: primaryColor.withOpacity(0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
