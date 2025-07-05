import 'package:hive/hive.dart';
part 'news_item.g.dart';

@HiveType(typeId: 0)
class NewsItem {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String summary;

  @HiveField(2)
  final String details;

  @HiveField(3)
  final String? sourceUrl;

  @HiveField(4)
  final String? date;

  @HiveField(5)
  final String responseType;

  @HiveField(6)
  final String? source;

  NewsItem({
    required this.title,
    required this.summary,
    required this.details,
    this.sourceUrl,
    this.source,
    required this.date,
    this.responseType = 'news',
  });
}