class MaterialsModel {
  final int id;
  final String name;
  final String unit;
  final int quantity;
  final DateTime addedAt;

  MaterialsModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.addedAt,
  });

  factory MaterialsModel.fromJson(Map<String, dynamic> json) {
    return MaterialsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      unit: json['unit'] as String,
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
