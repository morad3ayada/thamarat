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
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      unit: json['unit'] as String? ?? '',
      addedAt: DateTime.parse(json['addedAt'] as String? ?? DateTime.now().toIso8601String()),
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
