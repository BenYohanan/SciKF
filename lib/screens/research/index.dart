import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import '../../model/news_item.dart';
import '../../services/DatabaseHelper.dart';
import '../../services/PromptService.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_bottom_nav_bar.dart';
import '../../size_config.dart';
import 'Components/news_detail_screen.dart';

class ResearchScreen extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const ResearchScreen({super.key, required this.dbHelper});

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  late Future<List<NewsItem>> _newsFuture;
  String _country = "Nigeria";
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();

    final service = PromptService(widget.dbHelper);
    _newsFuture = service.fetchScienceNews();
    _loadCountry();
  }

  Future<void> _loadCountry() async {
    final service = PromptService(widget.dbHelper);
    final country = await service.getUserCountry();

    if (mounted) {
      setState(() {
        _country = country;
      });
    }
  }

  Future<void> _refresh() async {
    final service = PromptService(widget.dbHelper);

    setState(() {
      _newsFuture = service.fetchScienceNews(force: true);
    });

    await _newsFuture;
  }

  List<NewsItem> _filterByCategory(List<NewsItem> items) {
    if (_selectedCategory == "All") return items;

    return items.where((e) {
      final text =
      "${e.title} ${e.summary}".toLowerCase();

      if (_selectedCategory == "Health") {
        return text.contains("health");
      }
      if (_selectedCategory == "Agriculture") {
        return text.contains("agric");
      }
      if (_selectedCategory == "Environment") {
        return text.contains("environment");
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _refresh,
        child: FutureBuilder<List<NewsItem>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                children: [
                  SizedBox(height: getProportionateScreenHeight(200)),
                  Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return ListView(
                padding: EdgeInsets.all(getProportionateScreenHeight(20)),
                children: [
                  SizedBox(height: getProportionateScreenHeight(120)),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: getProportionateScreenHeight(50),
                          color: Colors.red,
                        ),
                        SizedBox(height: getProportionateScreenHeight(12)),
                        Text(
                          "Unable to load research",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(15),
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(8)),
                        Text(
                          "Please check your internet connection and try again.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              final service = PromptService(widget.dbHelper);
                              _newsFuture = service.fetchScienceNews(force: true);
                            });
                          },
                          child: Container(
                            height: getProportionateScreenHeight(45),
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenHeight(25),
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(
                                getProportionateScreenHeight(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Try Again",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }

            if (!snapshot.hasData) {
              return ListView(
                children: [
                  SizedBox(height: getProportionateScreenHeight(150)),
                  Center(
                    child: Text("No research found"),
                  ),
                ],
              );
            }

            final items = _filterByCategory(snapshot.data!);

            if (items.isEmpty) {
              return ListView(
                children: [
                  SizedBox(height: getProportionateScreenHeight(150)),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: getProportionateScreenHeight(50)),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        Text("No research found"),
                        SizedBox(height: getProportionateScreenHeight(6)),
                        Text("Pull down to refresh"),
                      ],
                    ),
                  )
                ],
              );
            }

            return ListView(
              padding: EdgeInsets.all(getProportionateScreenHeight(14)),
              children: [
                _header(),
                SizedBox(height: getProportionateScreenHeight(8)),
                _categories(),
                SizedBox(height: getProportionateScreenHeight(14)),

                ...items.map((e) => _newsCard(e)).toList(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trending in $_country",
          style: TextStyle(
            fontSize: getProportionateScreenHeight(16),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(4)),
        Text(
          "Latest research & discoveries",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _categories() {
    final categories = ["All", "Health", "Agriculture", "Environment"];

    return SizedBox(
      height: getProportionateScreenHeight(30),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: getProportionateScreenWidth(5)),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isActive = cat == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(12)),
              decoration: BoxDecoration(
                color: isActive ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(getProportionateScreenHeight(12)),
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.center,
              child: Text(
                cat,
                style: TextStyle(
                  color: isActive ? Colors.white : textColor,
                  fontSize: getProportionateScreenHeight(12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _newsCard(NewsItem item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(newsItem: item),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
        padding: EdgeInsets.all(getProportionateScreenHeight(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(getProportionateScreenHeight(12)),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: getProportionateScreenHeight(12),
                color: textColor
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(6)),

            Row(
              children: [
                Expanded(
                  child: Text(
                    item.date,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: getProportionateScreenHeight(10),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.source,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(10),
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(6)),
            Text(
              item.summary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}