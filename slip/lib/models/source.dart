class Source {
  final int id;
  final String name;
  final String url;
  final String description;

  Source({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'],
      url: json['url'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'url': url, 'description': description};
  }
}
