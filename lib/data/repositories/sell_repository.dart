import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/sell_model.dart';

class SellRepository {
  final ApiService _apiService;

  SellRepository(this._apiService);

  Future<List<SellModel>> fetchSellProcesses() async {
    final response = await _apiService.get(ApiConstants.sell);
    final data = response.data;
    if (data['success'] == true) {
      return (data['data'] as List)
          .map((e) => SellModel.fromJson(e))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to load sell processes');
    }
  }

  Future<SellModel> getSellDetails(int id) async {
    final response = await _apiService.get('${ApiConstants.sellDetails}/$id');
    final data = response.data;
    if (data['success'] == true) {
      return SellModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to get sell details');
    }
  }

  Future<void> confirmSell(int id) async {
    final response = await _apiService.post(
      ApiConstants.confirmSell,
      data: {'id': id},
    );
    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to confirm sell');
    }
  }
}
