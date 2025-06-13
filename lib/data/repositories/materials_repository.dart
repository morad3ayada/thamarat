import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/materials_model.dart';

class MaterialsRepository {
  final ApiService _apiService;

  MaterialsRepository(this._apiService);

  Future<List<MaterialsModel>> fetchMaterials() async {
    final response = await _apiService.get(ApiConstants.materials);
    final data = response.data;

    if (data['success'] == true) {
      return (data['data'] as List)
          .map((e) => MaterialsModel.fromJson(e))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to load materials');
    }
  }

  Future<void> addMaterial(MaterialsModel material) async {
    final response = await _apiService.post(
      ApiConstants.addMaterial,
      data: material.toJson(),
    );

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to add material');
    }
  }

  Future<void> deleteMaterial(int id) async {
    final response = await _apiService.delete('${ApiConstants.materials}/$id');
    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to delete material');
    }
  }
}
