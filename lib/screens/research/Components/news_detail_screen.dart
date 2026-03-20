import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';
import '../../../model/news_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import '../../../widgets/dialogs.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetailScreen({required this.newsItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: const CustomAppBar(),
      ),
      body: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsItem.title,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(17),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(8)),
            Text(
              'Date: ${newsItem.date}',
              style: TextStyle(
                fontSize: getProportionateScreenHeight(12),
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(8)),
            Text(
              'Source: ${newsItem.source}',
              style: TextStyle(
                fontSize: getProportionateScreenHeight(12),
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(8)),
            if (newsItem.responseType == 'news') ...[
              Text(
                newsItem.summary,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(16),
                  color: textColor,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Text(
                'Details:',
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(15),
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              Text(
                newsItem.details,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(16),
                  color: textColor,
                ),
              ),
            ] else ...[
              Text(
                'Response:',
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(15),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                newsItem.details,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(16),
                  color: Colors.black,
                ),
              ),
            ],
            if (newsItem.source != "SciKF" && newsItem.sourceUrl != null && newsItem.sourceUrl.isNotEmpty) ...[
              SizedBox(height: getProportionateScreenHeight(16)),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(newsItem.sourceUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      Dialogs.flushBar(context, "Error", "Could not launch URL");
                    }
                  },
                  icon: const Icon(
                    Icons.link,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Read From Source',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white, // For ripple effect
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(24),
                      vertical: getProportionateScreenHeight(12),
                    ),
                    minimumSize: Size(
                      getProportionateScreenWidth(200), // Responsive width
                      getProportionateScreenHeight(48),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: Colors.black26,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}