class UserModel {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? imageUrl;
  final String? token;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.imageUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'] ?? json['username'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      imageUrl: json['imageUrl'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
    };

    if (email != null) data['email'] = email;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (token != null) data['token'] = token;

    return data;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, email: $email, token: $token)';
  }
}
