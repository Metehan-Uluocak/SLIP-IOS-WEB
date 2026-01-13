class Leak {
  final int id;
  final String platformName;
  final String title;
  final String summary;
  final DateTime publishDate;
  final String sourceUrl;
  final String sourceName;

  Leak({
    required this.id,
    required this.platformName,
    required this.title,
    required this.summary,
    required this.publishDate,
    required this.sourceUrl,
    required this.sourceName,
  });

  factory Leak.fromJson(Map<String, dynamic> json) {
    return Leak(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      platformName: json['platformName'],
      title: json['title'],
      summary: json['summary'],
      publishDate: DateTime.parse(json['publishDate']),
      sourceUrl: json['sourceUrl'],
      sourceName: json['sourceName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platformName': platformName,
      'title': title,
      'summary': summary,
      'publishDate': publishDate.toIso8601String(),
      'sourceUrl': sourceUrl,
      'sourceName': sourceName,
    };
  }
}
