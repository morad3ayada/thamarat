class SellModel {
  final int id;
  final String customerName;
  final String customerPhone;
  final String materialName;
  final String fridgeName;
  final String sellType;
  final double quantity;
  final double price;
  final double? commission;
  final double? traderCommission;
  final double? officeCommission;
  final double? brokerage;
  final double? pieceRate;
  final double? weight;
  final String status;
  final DateTime date;
  final double totalPrice;

  SellModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.materialName,
    required this.fridgeName,
    required this.sellType,
    required this.quantity,
    required this.price,
    this.commission,
    this.traderCommission,
    this.officeCommission,
    this.brokerage,
    this.pieceRate,
    this.weight,
    required this.status,
    required this.date,
    required this.totalPrice,
  });

  factory SellModel.fromJson(Map<String, dynamic> json) {
    return SellModel(
      id: json['id'] as int? ?? 0,
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      materialName: json['materialName'] as String? ?? '',
      fridgeName: json['fridgeName'] as String? ?? '',
      sellType: json['sellType'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      commission: json['commission'] != null ? (json['commission'] as num).toDouble() : null,
      traderCommission: json['traderCommission'] != null ? (json['traderCommission'] as num).toDouble() : null,
      officeCommission: json['officeCommission'] != null ? (json['officeCommission'] as num).toDouble() : null,
      brokerage: json['brokerage'] != null ? (json['brokerage'] as num).toDouble() : null,
      pieceRate: json['pieceRate'] != null ? (json['pieceRate'] as num).toDouble() : null,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      status: json['status'] as String? ?? '',
      date: DateTime.parse(json['date'] as String? ?? DateTime.now().toIso8601String()),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'materialName': materialName,
      'fridgeName': fridgeName,
      'sellType': sellType,
      'quantity': quantity,
      'price': price,
      if (commission != null) 'commission': commission,
      if (traderCommission != null) 'traderCommission': traderCommission,
      if (officeCommission != null) 'officeCommission': officeCommission,
      if (brokerage != null) 'brokerage': brokerage,
      if (pieceRate != null) 'pieceRate': pieceRate,
      if (weight != null) 'weight': weight,
      'status': status,
      'date': date.toIso8601String(),
      'totalPrice': totalPrice,
    };
  }
}
