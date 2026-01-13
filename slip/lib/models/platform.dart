class Platform {
  final int id;
  final String name;
  final String description;

  Platform({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Platform.fromJson(Map<String, dynamic> json) {
    return Platform(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
