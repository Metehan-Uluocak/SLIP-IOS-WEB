enum UserRole { admin, analist, user }

class User {
  final int id;
  final String email;
  final String name;
  final UserRole role;
  final String? password;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: _parseRole(json['role']),
      password: json['password'],
    );
  }

  static UserRole _parseRole(dynamic role) {
    if (role is int) {
      return UserRole.values[role];
    }
    final roleStr = role.toString().toLowerCase();
    if (roleStr.contains('admin')) return UserRole.admin;
    if (roleStr.contains('analist')) return UserRole.analist;
    return UserRole.user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.index,
      if (password != null) 'password': password,
    };
  }
}
