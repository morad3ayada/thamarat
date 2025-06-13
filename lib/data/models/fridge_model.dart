class FridgeModel {
  final int id;
  final String name;
  final int quantity;
  final String unit;
  final DateTime addedAt;

  FridgeModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.addedAt,
  });

  factory FridgeModel.fromJson(Map<String, dynamic> json) {
    return FridgeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
