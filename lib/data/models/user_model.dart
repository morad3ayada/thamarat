class UserModel {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? imageUrl;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.imageUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      imageUrl: json['imageUrl'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      if (email != null) 'email': email,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (token != null) 'token': token,
    };
  }
}
