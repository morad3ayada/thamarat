class VendorModel {
  final int id;
  final String name;
  final String phoneNumber;
  final bool deleted;
  final List<InvoiceModel> invoices;

  VendorModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.deleted,
    required this.invoices,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
      invoices: (json['invoices'] as List<dynamic>?)
          ?.map((e) => InvoiceModel.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'deleted': deleted,
      'invoices': invoices.map((e) => e.toJson()).toList(),
    };
  }

  // Helper getter for total invoices count
  int get totalInvoicesCount => invoices.length;
  
  // Helper getter for total amount of all invoices
  double get totalAmount => invoices.fold(0, (sum, invoice) => sum + invoice.totalAmount);
}

class InvoiceModel {
  final int id;
  final int customerId;
  final String customerName;
  final int sellerId;
  final String sellerName;
  final bool sentToOffice;
  final DateTime createdAt;
  final List<MaterialModel> materials;
  final List<SpoiledMaterialModel> spoiledMaterials;

  InvoiceModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.sellerId,
    required this.sellerName,
    required this.sentToOffice,
    required this.createdAt,
    required this.materials,
    required this.spoiledMaterials,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as int? ?? 0,
      customerId: json['customerId'] as int? ?? 0,
      customerName: json['customerName'] as String? ?? '',
      sellerId: json['sellerId'] as int? ?? 0,
      sellerName: json['sellerName'] as String? ?? '',
      sentToOffice: json['sentToOffice'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
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
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sentToOffice': sentToOffice,
      'createdAt': createdAt.toIso8601String(),
      'materials': materials.map((e) => e.toJson()).toList(),
      'spoiledMaterials': spoiledMaterials.map((e) => e.toJson()).toList(),
    };
  }

  // Helper getter for total amount
  double get totalAmount {
    final materialsTotal = materials.fold(0.0, (sum, material) => sum + (material.price ?? 0));
    final spoiledTotal = spoiledMaterials.fold(0.0, (sum, material) => sum + (material.price ?? 0));
    return materialsTotal + spoiledTotal;
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
  });

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
  final double commissionPercentage;
  final double traderCommissionPercentage;
  final double officeCommissionPercentage;
  final double brokerCommissionPercentage;
  final double pieceFees;
  final double traderPiecePercentage;
  final double workerPiecePercentage;
  final double officePiecePercentage;

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
    required this.commissionPercentage,
    required this.traderCommissionPercentage,
    required this.officeCommissionPercentage,
    required this.brokerCommissionPercentage,
    required this.pieceFees,
    required this.traderPiecePercentage,
    required this.workerPiecePercentage,
    required this.officePiecePercentage,
  });

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
      commissionPercentage: json['commissionPercentage']?.toDouble() ?? 0.0,
      traderCommissionPercentage: json['traderCommissionPercentage']?.toDouble() ?? 0.0,
      officeCommissionPercentage: json['officeCommissionPercentage']?.toDouble() ?? 0.0,
      brokerCommissionPercentage: json['brokerCommissionPercentage']?.toDouble() ?? 0.0,
      pieceFees: json['pieceFees']?.toDouble() ?? 0.0,
      traderPiecePercentage: json['traderPiecePercentage']?.toDouble() ?? 0.0,
      workerPiecePercentage: json['workerPiecePercentage']?.toDouble() ?? 0.0,
      officePiecePercentage: json['officePiecePercentage']?.toDouble() ?? 0.0,
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
      'commissionPercentage': commissionPercentage,
      'traderCommissionPercentage': traderCommissionPercentage,
      'officeCommissionPercentage': officeCommissionPercentage,
      'brokerCommissionPercentage': brokerCommissionPercentage,
      'pieceFees': pieceFees,
      'traderPiecePercentage': traderPiecePercentage,
      'workerPiecePercentage': workerPiecePercentage,
      'officePiecePercentage': officePiecePercentage,
    };
  }
}
