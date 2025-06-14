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
    return FridgeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      isOpen: json['isOpen'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      materials: (json['materials'] as List<dynamic>?)
          ?.map((e) => MaterialResponseDto.fromJson(e))
          .toList() ?? [],
    );
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
    return MaterialResponseDto(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      materialType: json['materialType'] as String? ?? '',
      isQuantity: json['isQuantity'] as bool? ?? false,
    );
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
}
