class FridgeModel {
  final int id;
  final String name;
  final bool isOpen;
  final bool isDeleted;
  final List<MaterialResponseDto> materials;

  FridgeModel({
    required this.id,
    required this.name,
    required this.isOpen,
    required this.isDeleted,
    required this.materials,
  });

  factory FridgeModel.fromJson(Map<String, dynamic> json) {
    try {
      return FridgeModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        isOpen: json['isOpen'] as bool? ?? false,
        isDeleted: json['isDeleted'] as bool? ?? false,
        materials: (json['materials'] as List<dynamic>?)
            ?.map((e) => MaterialResponseDto.fromJson(e))
            .toList() ?? [],
      );
    } catch (e) {
      print('Error parsing FridgeModel: $e');
      // Return a default fridge model
      return FridgeModel(
        id: 0,
        name: 'براد غير معروف',
        isOpen: false,
        isDeleted: false,
        materials: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isOpen': isOpen,
      'isDeleted': isDeleted,
      'materials': materials.map((e) => e.toJson()).toList(),
    };
  }

  // Helper getter for quantity (sum of all materials)
  int get quantity => materials.length;
  
  // Helper getter for unit
  String get unit => 'مادة';
  
  // Helper getter for addedAt (using current date since API doesn't provide it)
  DateTime get addedAt => DateTime.now();
}

class MaterialResponseDto {
  final int id;
  final String name;
  final int order;
  final String materialType;
  final bool isQuantity;

  MaterialResponseDto({
    required this.id,
    required this.name,
    required this.order,
    required this.materialType,
    required this.isQuantity,
  });

  factory MaterialResponseDto.fromJson(Map<String, dynamic> json) {
    try {
      return MaterialResponseDto(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        order: json['order'] as int? ?? 0,
        materialType: json['materialType'] as String? ?? '',
        isQuantity: json['isQuantity'] as bool? ?? false,
      );
    } catch (e) {
      print('Error parsing MaterialResponseDto: $e');
      // Return a default material
      return MaterialResponseDto(
        id: 0,
        name: 'مادة غير معروفة',
        order: 0,
        materialType: '',
        isQuantity: false,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'materialType': materialType,
      'isQuantity': isQuantity,
    };
  }

  // Helper getter for source
  String get source => 'غير محدد';

  // Helper getter for display type
  String get displayType {
    switch (materialType) {
      case 'consignment':
        return 'صافي وزن';
      case 'markup':
        return 'خابط وزن';
      case 'spoiledConsignment':
        return 'صافي عدد';
      case 'spoiledMarkup':
        return 'خابط عدد';
      default:
        return materialType;
    }
  }
}
