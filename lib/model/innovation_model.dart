import '../constants.dart';

class InnovationModel {
  int? id;
  final String image, author, title, category;
  final String? status, date, fileUrl, authorEmail, summary;

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
  });

  factory InnovationModel.fromJson(Map<String, dynamic> json) {
    return InnovationModel(
      id: json['id'] as int?,
      author: json['author'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      fileUrl: json['file'] as String?,
      image: json['displayImage'] as String,
      status: json['status'] as String?,
      date: json['dateCreated'] as String?,
      summary: json['summary'] as String?,
      authorEmail: json['authorEmail'] as String?,
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
    };
  }
}

List<InnovationModel> recentInnovations = [
  InnovationModel(
      image: productDemoImg1,
      title: "CRISPR Breakthrough for Genetic Diseases",
      author: "Broad Institute",
      category: "Health Science",
  ),
  InnovationModel(
    image: productDemoImg4,
    title: "Carbon Capture Tech for Net-Zero Emissions",
    author: "Climeworks",
    category: "Environment",
  ),
  InnovationModel(
    image: productDemoImg5,
    title: "Vertical Farming for Sustainable Crops",
    author: "AeroFarms",
    category: "Agriculture",
  ),
  InnovationModel(
      image: productDemoImg6,
      title: "Wearable Sensors for Real-Time Health Monitoring",
      author: "MIT Media Lab",
      category: "Health",
  ),
];
List<InnovationModel> demoBestSellersProducts = [
  InnovationModel(
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "Green Poplin Ruched Front",
    author: "Lipsy london",
    category: "Agriculture",
  ),
  InnovationModel(
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    author: "Lipsy london",
    category: "Agriculture",
  ),
  InnovationModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    author: "Lipsy london",
    category: "Agriculture",
  ),
];
List<InnovationModel> kidsProducts = [
  InnovationModel(
    image: "https://i.imgur.com/dbbT6PA.png",
    title: "Green Poplin Ruched Front",
    author: "Lipsy london",
    category: "Agriculture",
  ),
  InnovationModel(
    image: "https://i.imgur.com/7fSxC7k.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    author: "Lipsy london",
    category: "Agriculture",
  ),
  InnovationModel(
    image: "https://i.imgur.com/pXnYE9Q.png",
    title: "Ruffle-Sleeve Ponte-Knit Sheath ",
    author: "Lipsy london",
    category: "Agriculture",
  ),
  InnovationModel(
    image: "https://i.imgur.com/V1MXgfa.png",
    title: "Green Mountain Beta Warehouse",
    author: "Lipsy london",
    category: "Agriculture",
  ),
  InnovationModel(
    image: "https://i.imgur.com/8gvE5Ss.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    author: "Lipsy london",
    category: "Agriculture",
  ),
  InnovationModel(
    image: "https://i.imgur.com/cBvB5YB.png",
    title: "Mountain Beta Warehouse",
    author: "Lipsy london",
    category: "Agriculture",
  ),
];
