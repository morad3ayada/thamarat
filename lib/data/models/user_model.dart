class UserModel {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? imageUrl;
  final String? token;
  final bool sellerPermission;
  final bool salePermissionForSpoiledMaterials;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.imageUrl,
    this.token,
    this.sellerPermission = false,
    this.salePermissionForSpoiledMaterials = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'] ?? json['username'] ?? '',
      phone: json['phone'] ?? json['phoneNumber'] ?? '',
      email: json['email'],
      imageUrl: json['imageUrl'],
      token: json['token'],
      sellerPermission: json['sellerPermission'] ?? false,
      salePermissionForSpoiledMaterials: json['salePermissionForSpoiledMaterials'] ?? false,
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
    data['sellerPermission'] = sellerPermission;
    data['salePermissionForSpoiledMaterials'] = salePermissionForSpoiledMaterials;

    return data;
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? imageUrl,
    String? token,
    bool? sellerPermission,
    bool? salePermissionForSpoiledMaterials,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      token: token ?? this.token,
      sellerPermission: sellerPermission ?? this.sellerPermission,
      salePermissionForSpoiledMaterials: salePermissionForSpoiledMaterials ?? this.salePermissionForSpoiledMaterials,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, email: $email, sellerPermission: $sellerPermission, salePermissionForSpoiledMaterials: $salePermissionForSpoiledMaterials)';
  }
}

class UpdateProfileRequest {
  final String username;
  final String email;
  final String phoneNumber;
  final String? currentPassword;
  final String? newPassword;

  const UpdateProfileRequest({
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.currentPassword,
    this.newPassword,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
    };

    // Only include password fields if both are provided
    if (currentPassword != null && currentPassword!.isNotEmpty && 
        newPassword != null && newPassword!.isNotEmpty) {
      data['currentPassword'] = currentPassword;
      data['newPassword'] = newPassword;
    }

    return data;
  }
}
