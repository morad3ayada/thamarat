import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/materials_model.dart';

class MaterialsRepository {
  final ApiService _apiService;

  MaterialsRepository(this._apiService);

  Future<List<MaterialsModel>> fetchMaterials() async {
    try {
      final response = await _apiService.get(ApiConstants.materials);
      final data = response.data;

      if (data['success'] == true) {
        final materialsList = (data['data'] as List)
            .map((e) => MaterialsModel.fromJson(e))
            .toList();
        
        // Sort materials by order
        materialsList.sort((a, b) => a.order.compareTo(b.order));
        
        return materialsList;
      } else {
        throw Exception(data['message'] ?? 'فشل في تحميل المواد');
      }
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('انتهت مهلة الاتصال. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.');
      } else if (e.toString().contains('connection refused')) {
        throw Exception('فشل الاتصال بالخادم. يرجى التحقق من أن التطبيق يعمل والمحاولة مرة أخرى.');
      } else {
        throw Exception('حدث خطأ أثناء تحميل المواد: ${e.toString()}');
      }
    }
  }

  Future<MaterialsModel> addMaterial(MaterialsModel material) async {
    try {
      final response = await _apiService.post(
        ApiConstants.addMaterial,
        data: material.toJson(),
      );

      final data = response.data;
      if (data['success'] == true) {
        return MaterialsModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'فشل في إضافة المادة');
      }
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.');
      } else if (e.toString().contains('connection refused')) {
        throw Exception('فشل الاتصال بالخادم. يرجى التحقق من الاتصال والمحاولة مرة أخرى.');
      } else {
        throw Exception('حدث خطأ أثناء إضافة المادة: ${e.toString()}');
      }
    }
  }

  Future<void> deleteMaterial(int id) async {
    try {
      final response = await _apiService.delete('${ApiConstants.deleteMaterial}?materialId=$id&materialType=markup');
      final data = response.data;
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'فشل في حذف المادة');
      }
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.');
      } else if (e.toString().contains('connection refused')) {
        throw Exception('فشل الاتصال بالخادم. يرجى التحقق من الاتصال والمحاولة مرة أخرى.');
      } else {
        throw Exception('حدث خطأ أثناء حذف المادة: ${e.toString()}');
      }
    }
  }
}
