import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../model/news_item.dart';
import 'DatabaseHelper.dart';

class PromptService {
  static const String apiKey = 'sk-proj-';
  static const String endpoint = 'https://api.openai.com/v1/responses';
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
        final country = data['country_name'] ?? "Nigeria";

        await dbHelper.saveTimestamp("user_country", country);

        return country;
      }
    } catch (_) {}

    return "Nigeria";
  }

  String _cleanJson(String text) {
    final start = text.indexOf('[');
    final end = text.lastIndexOf(']');
    if (start != -1 && end != -1) {
      return text.substring(start, end + 1);
    }
    return text;
  }

  Future<List<NewsItem>> fetchScienceNews({bool force = false}) async {
    try {
      final cachedTimestamp =
      await dbHelper.getTimestamp('scienceNewsTimestamp');

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

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-4.1-mini",
          "input": '''
            Provide a list of recent healthcare, agriculture, and science developments.
            
            PRIORITY COUNTRY: $country
            
            Focus primarily on $country, but include relevant global updates.
            
            Return ONLY valid JSON array like:
            [
              {
                "title": "...",
                "summary": "...",
                "date": "...",
                "source": "...",
                "sourceUrl": "...",
                "details": "..."
              }
            ]
            '''
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final outputText =
        data['output'][0]['content'][0]['text'];

        final cleaned = _cleanJson(outputText);
        final newsJson = jsonDecode(cleaned);

        final newsItems = (newsJson as List)
            .map((item) => NewsItem(
          title: item['title']?.toString() ?? '',
          summary: item['summary']?.toString() ?? '',
          details: item['details']?.toString() ?? '',
          sourceUrl: item['sourceUrl']?.toString() ?? '',
          source: item['source']?.toString() ?? '',
          date: item['date']?.toString() ?? '',
          responseType: 'news',
        ))
            .toList();

        await dbHelper.insertNewsItems(newsItems);
        await dbHelper.saveTimestamp(
          'scienceNewsTimestamp',
          DateTime.now().toIso8601String(),
        );

        return newsItems;
      } else {
        throw Exception(
            'Failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
  Future<NewsItem> answerPrompt(String prompt) async {
    try {
      final responseKey =
          'prompt_${md5.convert(utf8.encode(prompt)).toString()}';

      final country = await getUserCountry();

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-4.1-mini",
          "input": '''
            Provide detailed information about: "$prompt"
            
            PRIORITY COUNTRY: $country
            
            Return JSON:
            {
              "title": "...",
              "summary": "...",
              "details": "...",
              "source": "...",
              "sourceUrl": "...",
              "date": "YYYY-MM-DD"
            }
            '''
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final outputText =
        data['output'][0]['content'][0]['text'];

        final cleaned = outputText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        final item = jsonDecode(cleaned);

        final newsItem = NewsItem(
          title: item['title']?.toString() ?? '',
          summary: item['summary']?.toString() ?? '',
          details: item['details']?.toString() ?? '',
          sourceUrl: item['sourceUrl']?.toString() ?? '',
          source: item['source']?.toString() ?? 'SciKF',
          date: item['date']?.toString() ??
              DateTime.now().toIso8601String().split('T')[0],
          responseType: 'method',
        );

        await dbHelper.insertPromptResponse(responseKey, newsItem);

        return newsItem;
      } else {
        throw Exception(
            'Failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error processing prompt: $e');
    }
  }

  Future<List<NewsItem>> getCachedPromptResponses() async {
    return await dbHelper.getPromptResponses();
  }
}