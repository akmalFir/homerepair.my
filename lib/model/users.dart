class Users {
  final String name;
  final String? email;
  final String phone;
  final String? role;
  final String? userId;

  Users({
    required this.name,
    this.email,
    required this.phone,
    this.role,
    this.userId,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      role: json['role'] as String?,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'userId': userId,
    };
  }
}
