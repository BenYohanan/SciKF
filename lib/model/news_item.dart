class NewsItem {
  final String title;
  final String summary;
  final String details;
  final String sourceUrl;
  final String source;
  final String date;
  final String responseType;

  NewsItem({
    required this.title,
    required this.summary,
    required this.details,
    required this.sourceUrl,
    required this.source,
    required this.date,
    required this.responseType,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'details': details,
      'sourceUrl': sourceUrl,
      'source': source,
      'date': date,
      'responseType': responseType,
    };
  }

  factory NewsItem.fromMap(Map<String, dynamic> map) {
    return NewsItem(
      title: map['title'] ?? '',
      summary: map['summary'] ?? '',
      details: map['details'] ?? '',
      sourceUrl: map['sourceUrl'] ?? '',
      source: map['source'] ?? '',
      date: map['date'] ?? '',
      responseType: map['responseType'] ?? '',
    );
  }
}