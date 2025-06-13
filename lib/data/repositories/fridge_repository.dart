import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/fridge_model.dart';

class FridgeRepository {
  final ApiService _apiService;

  FridgeRepository(this._apiService);

  Future<List<FridgeModel>> fetchFridgeItems() async {
    final response = await _apiService.get(ApiConstants.fridges);
    final data = response.data;
    if (data['success'] == true) {
      return (data['data'] as List)
          .map((e) => FridgeModel.fromJson(e))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to load fridge items');
    }
  }

  Future<FridgeModel> getFridgeDetails(int id) async {
    final response = await _apiService.get("${ApiConstants.fridgeDetails}/$id");
    final data = response.data;
    if (data['success'] == true) {
      return FridgeModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to load fridge details');
    }
  }
}
