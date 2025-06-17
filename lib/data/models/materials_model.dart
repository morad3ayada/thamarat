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
    print('Material Type: $materialType, Is Quantity: $isQuantity'); // Debug log
    if (isQuantity) {
      switch (materialType) {
        case 'consignment':
          return 'صافي عدد';
        case 'markup':
          return 'خابط عدد';
        case 'spoiledConsignment':
          return 'صافي عدد';
        case 'spoiledMarkup':
          return 'خابط عدد';
        default:
          return 'صافي عدد';
      }
    } else {
      switch (materialType) {
        case 'consignment':
          return 'صافي وزن';
        case 'markup':
          return 'خابط وزن';
        case 'spoiledConsignment':
          return 'صافي وزن';
        case 'spoiledMarkup':
          return 'خابط وزن';
        default:
          return 'صافي وزن';
      }
    }
  }

  // Helper getter for source (truck name)
  String get source => truckName ?? 'غير محدد';
}
