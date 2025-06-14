class MaterialsModel {
  final int id;
  final String name;
  final String? truckName;
  final String materialType;
  final bool isQuantity;
  final int order;

  MaterialsModel({
    required this.id,
    required this.name,
    this.truckName,
    required this.materialType,
    required this.isQuantity,
    required this.order,
  });

  factory MaterialsModel.fromJson(Map<String, dynamic> json) {
    return MaterialsModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      truckName: json['truckName'] as String?,
      materialType: json['materialType'] as String? ?? '',
      isQuantity: json['isQuantity'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'truckName': truckName,
      'materialType': materialType,
      'isQuantity': isQuantity,
      'order': order,
    };
  }

  // Helper getter for display type
  String get displayType {
    switch (materialType) {
      case 'consignment':
        return 'صافي';
      case 'markup':
        return 'ربح';
      case 'spoiledConsignment':
        return 'صافي تالف';
      case 'spoiledMarkup':
        return 'ربح تالف';
      default:
        return materialType;
    }
  }

  // Helper getter for source (truck name)
  String get source => truckName ?? 'غير محدد';
}
