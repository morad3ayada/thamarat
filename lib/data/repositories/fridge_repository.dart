import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/fridge_model.dart';

class FridgeRepository {
  final ApiService _apiService;

  FridgeRepository(this._apiService);

  Future<List<FridgeModel>> fetchFridgeItems() async {
    try {
      final response = await _apiService.get(ApiConstants.fridges);
      final data = response.data;
      if (data['success'] == true) {
        final allFridges = (data['data'] as List)
            .map((e) => FridgeModel.fromJson(e))
            .toList();
        
        // Filter only open and non-deleted fridges
        return allFridges.where((fridge) => fridge.isOpen && !fridge.isDeleted).toList();
      } else {
        throw Exception(data['message'] ?? 'فشل في تحميل قائمة البرادات');
      }
    } catch (e) {
      print('Error in fetchFridgeItems: $e');
      if (e.toString().contains('Connection refused') || e.toString().contains('timeout')) {
        throw Exception('فشل في الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت');
      }
      rethrow;
    }
  }

  Future<FridgeModel> getFridgeDetails(int id) async {
    try {
      final response = await _apiService.get("${ApiConstants.fridgeById}$id");
      final data = response.data;
      if (data['success'] == true) {
        final fridge = FridgeModel.fromJson(data['data']);
        if (fridge.isDeleted) {
          throw Exception('البراد غير موجود أو محذوف');
        }
        return fridge;
      } else {
        throw Exception(data['message'] ?? 'فشل في تحميل تفاصيل البراد');
      }
    } catch (e) {
      print('Error in getFridgeDetails: $e');
      if (e.toString().contains('Connection refused') || e.toString().contains('timeout')) {
        throw Exception('فشل في الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت');
      }
      // Return a default fridge model instead of throwing
      return FridgeModel(
        id: id,
        name: 'براد غير معروف',
        isOpen: false,
        isDeleted: false,
        materials: [],
      );
    }
  }
}
