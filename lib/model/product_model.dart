import '../constants.dart';

class InnovationModel {
  final String image, author, title, category;

  InnovationModel({
    required this.image,
    required this.author,
    required this.title,
    required this.category,
  });
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
