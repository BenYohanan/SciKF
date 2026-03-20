import '../constants.dart';

class InnovationModel {
  int? id;
  final String image, author, title, category;
  final String? status, date, fileUrl, authorEmail, summary, authorId, displayType;

  InnovationModel({
    this.id,
    required this.image,
    required this.author,
    required this.title,
    required this.category,
    this.status,
    this.date,
    this.fileUrl,
    this.authorEmail,
    this.summary,
    this.authorId,
    this.displayType
  });

  factory InnovationModel.fromJson(Map<String, dynamic> json) {
    return InnovationModel(
      id: json['id'] as int?,
      author: json['author'] != null ? json['author'] as String : "",
      category: json['category'] != null ? json['category'] as String : "",
      title: json['title'] != null ? json['title'] as String : "",
      fileUrl: json['file'] != null ? '$imgBaseUrl/uploads/${json['file']}' : "",
      image: json['displayImage'] != null ? '$imgBaseUrl/uploads/${json['displayImage']}' : "",
      status: json['status'] as String?,
      date: json['dateCreated'] as String?,
      summary: json['summary'] as String?,
      authorEmail: json['authorEmail'] as String?,
      authorId: json['authorId'] as String?,
      displayType: json['type'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'author': author,
      'title': title,
      'category': category,
      'status': status,
      'date': date,
      'fileUrl': fileUrl,
      'summary': summary,
      'authorEmail': authorEmail,
      'authorId': authorId,
      'displayType': displayType,
    };
  }
}
