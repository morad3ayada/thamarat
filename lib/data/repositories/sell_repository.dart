import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/sell_model.dart';

class SellRepository {
  final ApiService _apiService;

  SellRepository(this._apiService);

  Future<List<SellModel>> fetchSellProcesses() async {
    final response = await _apiService.get(ApiConstants.saleProcesses);
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
    final response = await _apiService.get('${ApiConstants.getSaleProcess}/$id');
    final data = response.data;
    if (data['success'] == true) {
      return SellModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to get sell details');
    }
  }

  Future<void> confirmSell(int id) async {
    final response = await _apiService.post(
      ApiConstants.sendToOffice,
      data: {'id': id},
    );
    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to confirm sell');
    }
  }

  Future<void> addSellMaterial({
    required String customerName,
    required String customerPhone,
    required String materialName,
    required String fridgeName,
    required String sellType,
    required double quantity,
    required double price,
    double? commission,
    double? traderCommission,
    double? officeCommission,
    double? brokerage,
    double? pieceRate,
    double? weight,
  }) async {
    final response = await _apiService.post(
      ApiConstants.addSaleProcess,
      data: {
        'customerName': customerName,
        'customerPhone': customerPhone,
        'materialName': materialName,
        'fridgeName': fridgeName,
        'sellType': sellType,
        'quantity': quantity,
        'price': price,
        if (commission != null) 'commission': commission,
        if (traderCommission != null) 'traderCommission': traderCommission,
        if (officeCommission != null) 'officeCommission': officeCommission,
        if (brokerage != null) 'brokerage': brokerage,
        if (pieceRate != null) 'pieceRate': pieceRate,
        if (weight != null) 'weight': weight,
      },
    );
    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to add sell material');
    }
  }
}
