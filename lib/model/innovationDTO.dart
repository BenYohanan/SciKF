enum Category {Select, Agriculture, EnvironmentalScience, Healthcare }
enum Status { Pending, Approved, Rejected }
extension JobStatusExtension on Category {
  String get displayName {
    switch (this) {
      case Category.Select:
        return 'Select Category';
      case Category.Agriculture:
        return 'Agriculture';
      case Category.EnvironmentalScience:
        return 'Environmental Science';
      case Category.Healthcare:
        return 'Health Care';
    }
  }
}

class InnovationDTO {
  String? title;
  String? summary;
  String? authorId;
  Category? category;
  String? file;
  String? displayImage;

  InnovationDTO({
    this.title,
    this.summary,
    this.authorId,
    this.category,
    this.file,
    this.displayImage
  });


  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Summary': summary,
      'AuthorId': authorId,
      'DisplayImage': displayImage,
      'File' : file,
      'Category': category
    };
  }
}