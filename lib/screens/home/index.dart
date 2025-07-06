import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import '../../model/news_item.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../size_config.dart';
import 'Components/news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}
class HomeScreenState extends State<HomeScreen> {
  List<NewsItem> newsItems = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final fetchedNews = await ApiService().fetchScienceNews();
    if (mounted) {
      setState(() {
        newsItems = fetchedNews;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(fullName: "User", isOnline: true),
      ),
      body: newsItems.isEmpty
          ? Center(
        child: Text(
          'No news available. Please try again later.',
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(getProportionateScreenHeight(16)),
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          final newsItem = newsItems[index];
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
                          newsItem.date ?? 'N/A',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        Text(
                          newsItem.source ?? 'AI Generated',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(12),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
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
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}