import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../model/news_item.dart';
import 'DatabaseHelper.dart';

class PromptService {
  static const String apiKey = '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';
  static const String endpoint = 'https://api.openai.com/v1/chat/completions';
  final DatabaseHelper dbHelper;

  PromptService(this.dbHelper);

  Future<List<NewsItem>> fetchScienceNews() async {
    final cachedTimestamp = await dbHelper.getTimestamp('scienceNewsTimestamp');
    if (cachedTimestamp != null) {
      final lastCached = DateTime.parse(cachedTimestamp);
      final now = DateTime.now();
      if (lastCached.day == now.day &&
          lastCached.month == now.month &&
          lastCached.year == now.year) {
        return await dbHelper.getNewsItems();
      }
    }

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'user',
            'content': '''
              Provide a comprehensive list of recent events, discoveries, or findings in healthcare, agriculture, and health sciences, with a primary focus on Nigeria, but also including relevant global developments. Include as many entries as possible, prioritizing recency (within the last 12 months) and relevance. For each entry, provide the following details in JSON format:
              {
                "title": "A concise, descriptive title for the event, discovery, or finding",
                "summary": "A brief summary (2-3 sentences) describing the event, discovery, or finding and its significance",
                "date": "The date of the event or publication (in YYYY-MM-DD format, or approximate month/year if exact date is unavailable)",
                "source": "The name of the source (e.g., journal, news outlet, organization) or 'SciKF' if no specific source is identified",
                "sourceUrl": "A working, direct URL to the source article or report (ensure the link is accessible and valid; if none exists, provide an empty string '')",
                "details": "A well detailed explanation providing context, key findings, implications, and any relevant stakeholders (e.g., researchers, institutions, or organizations involved)"
              }
              Ensure the response is well-organized, prioritizes Nigerian developments, and includes global examples for broader context. Verify all URLs and exclude any broken or inaccessible links. If information is limited, note any gaps and provide the best available data. Return the response as a JSON array of objects.
              '''
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newsJson = jsonDecode(data['choices'][0]['message']['content']);
      final newsItems = (newsJson as List).map((item) => NewsItem(
        title: item['title']?.toString() ?? '',
        summary: item['summary']?.toString() ?? '',
        details: item['details']?.toString() ?? '',
        sourceUrl: item['sourceUrl']?.toString() ?? '',
        source: item['source']?.toString() ?? '',
        date: item['date']?.toString() ?? '',
        responseType: 'news',
      )).toList();

      await dbHelper.insertNewsItems(newsItems);
      await dbHelper.saveTimestamp('scienceNewsTimestamp', DateTime.now().toIso8601String());
      return newsItems;
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  Future<NewsItem> answerPrompt(String prompt) async {
    final responseKey = 'prompt_${md5.convert(utf8.encode(prompt)).toString()}';
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'user',
            'content': '''
                Provide detailed information about methods, techniques, or findings in healthcare, agriculture, or health sciences related to the topic: "$prompt". Prioritize Nigerian research, innovations, or context if available; otherwise, include relevant global scientific information. Format the response as a single JSON object with the following fields:
                {
                  "title": "A concise, descriptive title for the method, technique, or finding",
                  "summary": "A brief summary (2-3 sentences) describing the method or finding and its significance",
                  "details": "A well detailed explanation covering the method or finding, its application, key results, implications, and relevant stakeholders (e.g., researchers, institutions, organizations)",
                  "source": "The name of the source (e.g., journal, news outlet, organization) or 'SciKF' if no specific source is identified",
                  "sourceUrl": "A working, direct URL to the source article or report (ensure the link is valid; use an empty string '' if none exists)",
                  "date": "The date of the finding or publication in YYYY-MM-DD format; use the current date (${DateTime.now().toIso8601String().split('T')[0]}) if no specific date is available"
                }
                Ensure the response is accurate, well-organized, and prioritizes Nigerian context where applicable. Verify all URLs and exclude any broken or inaccessible links. If information is limited, note any gaps and provide the best available data.
                '''
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final item = jsonDecode(data['choices'][0]['message']['content']);
      final newsItem = NewsItem(
        title: item['title']?.toString() ?? '',
        summary: item['summary']?.toString() ?? '',
        details: item['details']?.toString() ?? '',
        sourceUrl: item['sourceUrl']?.toString() ?? '',
        source: item['source']?.toString() ?? 'SciKF',
        date: item['date']?.toString() ?? DateTime.now().toIso8601String().split('T')[0],
        responseType: 'method',
      );

      await dbHelper.insertPromptResponse(responseKey, newsItem);
      return newsItem;
    } else {
      throw Exception('Failed to get response');
    }
  }

  Future<List<NewsItem>> getCachedPromptResponses() async {
    return await dbHelper.getPromptResponses();
  }
}