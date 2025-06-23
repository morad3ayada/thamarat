class SellModel {
  final int id;
  final int customerId;
  final String customerName;
  final String customerPhone;
  final int sellerId;
  final String sellerName;
  final bool sentToOffice;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<MaterialModel> materials;
  final List<SpoiledMaterialModel> spoiledMaterials;

  SellModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.sellerId,
    required this.sellerName,
    required this.sentToOffice,
    required this.createdAt,
    this.updatedAt,
    required this.materials,
    required this.spoiledMaterials,
  });

  factory SellModel.fromJson(Map<String, dynamic> json) {
    return SellModel(
      id: json['id'] as int? ?? 0,
      customerId: json['customerId'] as int? ?? 0,
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      sellerId: json['sellerId'] as int? ?? 0,
      sellerName: json['sellerName'] as String? ?? '',
      sentToOffice: json['sentToOffice'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      materials: (json['materials'] as List<dynamic>?)
          ?.map((e) => MaterialModel.fromJson(e))
          .toList() ?? [],
      spoiledMaterials: (json['spoiledMaterials'] as List<dynamic>?)
          ?.map((e) => SpoiledMaterialModel.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sentToOffice': sentToOffice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'materials': materials.map((e) => e.toJson()).toList(),
      'spoiledMaterials': spoiledMaterials.map((e) => e.toJson()).toList(),
    };
  }

  // Helper method to get all materials (normal + spoiled)
  List<dynamic> getAllMaterials() {
    return [...materials, ...spoiledMaterials];
  }

  // Helper method to calculate total price
  double get totalPrice {
    double total = 0;
    for (var material in materials) {
      total += material.totalPrice;
    }
    for (var material in spoiledMaterials) {
      total += material.totalPrice;
    }
    return total;
  }

  // Helper method to get materials count
  int get materialsCount {
    return materials.length + spoiledMaterials.length;
  }

  // Helper method to get the most recent update time
  DateTime get lastUpdateTime {
    return updatedAt ?? createdAt;
  }
}

class MaterialModel {
  final int id;
  final String name;
  final String sellerName;
  final String truckName;
  final bool isQuantity;
  final double? quantity;
  final double? weight;
  final double? price;
  final int order;
  final String materialType;
  final double? commission;
  final double totalPrice;

  MaterialModel({
    required this.id,
    required this.name,
    required this.sellerName,
    required this.truckName,
    required this.isQuantity,
    this.quantity,
    this.weight,
    this.price,
    required this.order,
    required this.materialType,
    this.commission,
    required this.totalPrice,
  });

  // Helper method to generate unique material ID
  String get uniqueId {
    String prefix = materialType.startsWith('consignment') ? 'c' : 'm';
    return '$prefix$id';
  }

  // Helper method to parse unique ID back to original ID
  static int parseId(String uniqueId) {
    return int.parse(uniqueId.substring(1));
  }

  // Helper method to get material type from unique ID
  static String getTypeFromId(String uniqueId) {
    return uniqueId.startsWith('c') ? 'consignment' : 'markup';
  }

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      sellerName: json['sellerName'] as String? ?? '',
      truckName: json['truckName'] as String? ?? '',
      isQuantity: json['isQuantity'] as bool? ?? false,
      quantity: json['quantity']?.toDouble(),
      weight: json['weight']?.toDouble(),
      price: json['price']?.toDouble(),
      order: json['order'] as int? ?? 0,
      materialType: json['materialType'] as String? ?? '',
      commission: json['commission']?.toDouble(),
      totalPrice: json['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sellerName': sellerName,
      'truckName': truckName,
      'isQuantity': isQuantity,
      'quantity': quantity,
      'weight': weight,
      'price': price,
      'order': order,
      'materialType': materialType,
      'commission': commission,
      'totalPrice': totalPrice,
    };
  }
}

class SpoiledMaterialModel {
  final int id;
  final String name;
  final String sellerName;
  final String truckName;
  final bool isQuantity;
  final double? quantity;
  final double? weight;
  final double? price;
  final int order;
  final String materialType;
  final bool isRate;
  final double? commissionPercentage;
  final double? traderCommissionPercentage;
  final double? officeCommissionPercentage;
  final double? brokerCommissionPercentage;
  final double? pieceFees;
  final double? traderPiecePercentage;
  final double? workerPiecePercentage;
  final double? officePiecePercentage;
  final double? brokerPiecePercentage;
  final double totalPrice;

  SpoiledMaterialModel({
    required this.id,
    required this.name,
    required this.sellerName,
    required this.truckName,
    required this.isQuantity,
    this.quantity,
    this.weight,
    this.price,
    required this.order,
    required this.materialType,
    required this.isRate,
    this.commissionPercentage,
    this.traderCommissionPercentage,
    this.officeCommissionPercentage,
    this.brokerCommissionPercentage,
    this.pieceFees,
    this.traderPiecePercentage,
    this.workerPiecePercentage,
    this.officePiecePercentage,
    this.brokerPiecePercentage,
    required this.totalPrice,
  });

  // Helper method to generate unique material ID
  String get uniqueId {
    String prefix = materialType.startsWith('spoiledConsignment') ? 'sc' : 'sm';
    return '$prefix$id';
  }

  // Helper method to parse unique ID back to original ID
  static int parseId(String uniqueId) {
    return int.parse(uniqueId.substring(2));
  }

  // Helper method to get material type from unique ID
  static String getTypeFromId(String uniqueId) {
    return uniqueId.startsWith('sc') ? 'spoiledConsignment' : 'spoiledMarkup';
  }

  factory SpoiledMaterialModel.fromJson(Map<String, dynamic> json) {
    return SpoiledMaterialModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      sellerName: json['sellerName'] as String? ?? '',
      truckName: json['truckName'] as String? ?? '',
      isQuantity: json['isQuantity'] as bool? ?? false,
      quantity: json['quantity']?.toDouble(),
      weight: json['weight']?.toDouble(),
      price: json['price']?.toDouble(),
      order: json['order'] as int? ?? 0,
      materialType: json['materialType'] as String? ?? '',
      isRate: json['isRate'] as bool? ?? false,
      commissionPercentage: json['commissionPercentage']?.toDouble(),
      traderCommissionPercentage: json['traderCommissionPercentage']?.toDouble(),
      officeCommissionPercentage: json['officeCommissionPercentage']?.toDouble(),
      brokerCommissionPercentage: json['brokerCommissionPercentage']?.toDouble(),
      pieceFees: json['pieceFees']?.toDouble(),
      traderPiecePercentage: json['traderPiecePercentage']?.toDouble(),
      workerPiecePercentage: json['workerPiecePercentage']?.toDouble(),
      officePiecePercentage: json['officePiecePercentage']?.toDouble(),
      brokerPiecePercentage: json['brokerPiecePercentage']?.toDouble(),
      totalPrice: json['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sellerName': sellerName,
      'truckName': truckName,
      'isQuantity': isQuantity,
      'quantity': quantity,
      'weight': weight,
      'price': price,
      'order': order,
      'materialType': materialType,
      'isRate': isRate,
      'commissionPercentage': commissionPercentage,
      'traderCommissionPercentage': traderCommissionPercentage,
      'officeCommissionPercentage': officeCommissionPercentage,
      'brokerCommissionPercentage': brokerCommissionPercentage,
      'pieceFees': pieceFees,
      'traderPiecePercentage': traderPiecePercentage,
      'workerPiecePercentage': workerPiecePercentage,
      'officePiecePercentage': officePiecePercentage,
      'brokerPiecePercentage': brokerPiecePercentage,
      'totalPrice': totalPrice,
    };
  }
}
