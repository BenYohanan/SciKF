import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../model/news_item.dart';
import '../../../services/DatabaseHelper.dart';
import '../../../services/api_service.dart';
import '../../../size_config.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import '../../../widgets/dialogs.dart';
import 'news_detail_screen.dart';

class ResponseListScreen extends StatefulWidget {
  final DatabaseHelper dbHelper;
  const ResponseListScreen({super.key, required this.dbHelper});
  @override
  State<ResponseListScreen> createState() => _ResponseListScreenState();
}

class _ResponseListScreenState extends State<ResponseListScreen> {
  late Future<List<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = ApiService(widget.dbHelper).getCachedPromptResponses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Dialogs.loader(context);
            });
            return const SizedBox.shrink();
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context, rootNavigator: true).pop();
          });

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load news: ${snapshot.error}',
                style: TextStyle(fontSize: getProportionateScreenWidth(16)),
              ),
            );
          }

          final newsItems = snapshot.data ?? [];
          if (newsItems.isEmpty) {
            return Center(
              child: Text(
                'No prompt yet!',
                style: TextStyle(fontSize: getProportionateScreenWidth(16)),
              ),
            );
          }

          return ListView.builder(
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
                              newsItem.date,
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(14),
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              newsItem.source,
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(12),
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
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
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}