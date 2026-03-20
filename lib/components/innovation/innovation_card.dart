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
    this.displayType,
  });

  final String image;
  final String author;
  final String title;
  final String category;
  final VoidCallback press;
  final String? displayType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(140),
                  width: double.infinity,
                  child: image.isEmpty
                      ? Image.asset('assets/img/NoImg.png', fit: BoxFit.cover)
                      : NetworkImageWithLoader(image, fit: BoxFit.cover),
                ),

                if (displayType != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: displayType == "Flash"
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        displayType == "Flash" ? "⚡" : "🔥",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(getProportionateScreenHeight(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(12),
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  SizedBox(height: getProportionateScreenHeight(4)),

                  Text(
                    category,
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(10),
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: getProportionateScreenHeight(2)),

                  Text(
                    author,
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(10),
                      color: Colors.grey.shade600,
                    ),
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