import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../constants.dart';
import '../model/news_item.dart';
import 'DatabaseHelper.dart';

class PromptService {
  static const String apiBaseUrl = '$baseUrl/Innovation';

  final DatabaseHelper dbHelper;

  PromptService(this.dbHelper);

  Future<String> getUserCountry() async {
    try {
      final cached = await dbHelper.getTimestamp("user_country");

      if (cached != null && cached.isNotEmpty) {
        return cached;
      }

      final response = await http.get(Uri.parse("https://ipapi.co/json/"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final country = data['country_name']?.toString() ?? "Nigeria";

        await dbHelper.saveTimestamp("user_country", country);

        return country;
      }
    } catch (_) {}

    return "Nigeria";
  }

  Future<String> getUserId() async {
    final userId = await dbHelper.getTimestamp("user_id");

    if (userId != null && userId.isNotEmpty) {
      return userId;
    }

    return "";
  }

  NewsItem _mapToNewsItem(dynamic item, {String responseType = 'news'}) {
    return NewsItem(
      title: item['title']?.toString() ?? '',
      summary: item['summary']?.toString() ?? '',
      details: item['details']?.toString() ?? '',
      sourceUrl: item['sourceUrl']?.toString() ?? '',
      source: item['source']?.toString() ?? 'SciKF',
      date: item['date']?.toString() ?? DateTime.now().toIso8601String().split('T')[0],
      responseType: responseType,
    );
  }

  Future<List<NewsItem>> fetchScienceNews({bool force = false}) async {
    try {
      final cachedTimestamp = await dbHelper.getTimestamp('scienceNewsTimestamp');

      if (!force && cachedTimestamp != null) {
        final lastCached = DateTime.parse(cachedTimestamp);
        final now = DateTime.now();

        if (lastCached.day == now.day &&
            lastCached.month == now.month &&
            lastCached.year == now.year) {
          return await dbHelper.getNewsItems();
        }
      }

      final country = await getUserCountry();
      final userId = await getUserId();

      final response = await http.post(
        Uri.parse('$apiBaseUrl/FetchScienceNews'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "userId": userId,
          "country": country,
          "userPrompt": null,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed: ${response.statusCode} ${response.body}');
      }

      final data = jsonDecode(response.body);
      final newsJson = data['news'];

      if (newsJson == null || newsJson is! List) {
        throw Exception('Invalid news response from server');
      }

      final newsItems = newsJson
          .map((item) => _mapToNewsItem(item, responseType: 'news'))
          .toList();

      await dbHelper.insertNewsItems(newsItems);
      await dbHelper.saveTimestamp(
        'scienceNewsTimestamp',
        DateTime.now().toIso8601String(),
      );

      return newsItems;
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  Future<NewsItem> answerPrompt(String prompt) async {
    try {
      final responseKey = 'prompt_${md5.convert(utf8.encode(prompt)).toString()}';

      final country = await getUserCountry();
      final userId = await getUserId();

      final response = await http.post(
        Uri.parse('$apiBaseUrl/AnswerPrompt'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "userId": userId,
          "country": country,
          "userPrompt": prompt,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed: ${response.statusCode} ${response.body}');
      }

      final data = jsonDecode(response.body);
      final result = data['result'];

      if (result == null) {
        throw Exception('Invalid prompt response from server');
      }

      NewsItem newsItem;

      if (result is String) {
        newsItem = NewsItem(
          title: prompt,
          summary: result,
          details: result,
          sourceUrl: '',
          source: 'SciKF',
          date: DateTime.now().toIso8601String().split('T')[0],
          responseType: 'method',
        );
      } else {
        newsItem = _mapToNewsItem(result, responseType: 'method');
      }

      await dbHelper.insertPromptResponse(responseKey, newsItem);

      return newsItem;
    } catch (e) {
      throw Exception('Error processing prompt: $e');
    }
  }

  Future<List<NewsItem>> getCachedPromptResponses() async {
    return await dbHelper.getPromptResponses();
  }
}