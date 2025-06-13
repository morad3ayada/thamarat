class SellModel {
  final int id;
  final String materialName;
  final int quantity;
  final double price;
  final String status;
  final DateTime createdAt;

  SellModel({
    required this.id,
    required this.materialName,
    required this.quantity,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory SellModel.fromJson(Map<String, dynamic> json) {
    return SellModel(
      id: json['id'] as int,
      materialName: json['materialName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materialName': materialName,
      'quantity': quantity,
      'price': price,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
