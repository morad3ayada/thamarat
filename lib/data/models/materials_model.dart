class MaterialsModel {
  final int id;
  final String name;
  final String type;
  final String source;
  final String quantity;
  final String price;
  final DateTime addedAt;

  MaterialsModel({
    required this.id,
    required this.name,
    required this.type,
    required this.source,
    required this.quantity,
    required this.price,
    required this.addedAt,
  });

  factory MaterialsModel.fromJson(Map<String, dynamic> json) {
    return MaterialsModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      source: json['source'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      price: json['price'] as String? ?? '',
      addedAt: DateTime.parse(json['addedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'source': source,
      'quantity': quantity,
      'price': price,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
