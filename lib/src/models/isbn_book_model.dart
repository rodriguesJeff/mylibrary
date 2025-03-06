class IsbnBookModel {
  String isbn;
  String title;
  String subtitle;
  List<String> authors;
  String publisher;
  String synopsis;
  Dimensions dimensions;
  int year;
  String format;
  int pageCount;
  List<String> subjects;
  String location;
  double? retailPrice;
  String? coverUrl;
  String provider;

  IsbnBookModel({
    required this.isbn,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.publisher,
    required this.synopsis,
    required this.dimensions,
    required this.year,
    required this.format,
    required this.pageCount,
    required this.subjects,
    required this.location,
    this.retailPrice,
    this.coverUrl,
    required this.provider,
  });

  factory IsbnBookModel.fromJson(Map<String, dynamic> json) {
    return IsbnBookModel(
      isbn: json['isbn'],
      title: json['title'],
      subtitle: json['subtitle'],
      authors: List<String>.from(json['authors']),
      publisher: json['publisher'],
      synopsis: json['synopsis'],
      dimensions: Dimensions.fromJson(json['dimensions']),
      year: json['year'],
      format: json['format'],
      pageCount: json['page_count'],
      subjects: List<String>.from(json['subjects']),
      location: json['location'],
      retailPrice: json['retail_price']?.toDouble(),
      coverUrl: json['cover_url'],
      provider: json['provider'],
    );
  }
}

class Dimensions {
  double width;
  double height;
  String unit;

  Dimensions({
    required this.width,
    required this.height,
    required this.unit,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      unit: json['unit'],
    );
  }
}
