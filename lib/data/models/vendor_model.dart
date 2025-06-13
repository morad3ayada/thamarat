class VendorModel {
  final int id;
  final String name;
  final String location;
  final String phone;
  final String? imageUrl;
  final int fridgesCount;
  final DateTime lastVisit;

  VendorModel({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    this.imageUrl,
    this.fridgesCount = 0,
    required this.lastVisit,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      fridgesCount: json['fridgesCount'] as int? ?? 0,
      lastVisit: DateTime.parse(json['lastVisit'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phone': phone,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'fridgesCount': fridgesCount,
      'lastVisit': lastVisit.toIso8601String(),
    };
  }
}
