import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/news_item.dart';
import '../services/api_service.dart';
import '../size_config.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'home/Components/news_detail_screen.dart';

class ResponseListScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(fullName: "User", isOnline: true),
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: _apiService.getCachedPromptResponses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No prompt yet'));
          }
          final news = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(getProportionateScreenHeight(16)),
            itemCount: news.length,
            itemBuilder: (context, index) {
              final newsItem = news[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(newsItem: newsItem),
                  ),
                ),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenHeight(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsItem.title,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: getProportionateScreenHeight(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              newsItem.date!,
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(14),
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor, // Nigerian green
                              ),
                            ),
                            Text(
                              newsItem.source ?? 'AI Generated',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(12),
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor, // Nigerian green
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(8)),
                        Text(
                          newsItem.summary,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            color: Colors.grey[600],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
        bottomNavigationBar: CustomBottomNavBar()
    );
  }
}