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
    final response = await _apiService.get('${ApiConstants.getSaleProcess}$id');
    final data = response.data;
    if (data['success'] == true) {
      return SellModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to get sell details');
    }
  }

  Future<Map<String, dynamic>> createNewSaleProcess({
    required int customerId,
    required String customerName,
    required String customerPhone,
  }) async {
    final response = await _apiService.post(
      ApiConstants.addSaleProcess,
      data: {
        'customerId': customerId,
        'customerName': customerName,
        'customerPhone': customerPhone,
      },
    );
    final data = response.data;
    if (data['success'] == true) {
      return data['data'];
    } else {
      throw Exception(data['message'] ?? 'Failed to create new sale process');
    }
  }

  Future<void> confirmSell(int id) async {
    final response = await _apiService.post(
      '${ApiConstants.sendToOffice}$id/send-to-office',
    );
    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to confirm sell');
    }
  }

  Future<void> addMaterialToSaleProcess({
    required int saleProcessId,
    required int materialId,
    required String materialType,
    required double? price,
    double? quantity,
    double? weight,
    bool? isRate,
    double? commissionPercentage,
    double? traderCommissionPercentage,
    double? officeCommissionPercentage,
    double? brokerCommissionPercentage,
    double? pieceFees,
    double? traderPiecePercentage,
    double? workerPiecePercentage,
    double? officePiecePercentage,
    double? brokerPiecePercentage,
  }) async {
    final response = await _apiService.post(
      ApiConstants.addMaterial,
      data: {
        'saleProcessId': saleProcessId,
        'materialId': materialId,
        'materialType': materialType,
        'price': price,
        'quantity': quantity,
        'weight': weight,
        'isRate': isRate,
        'commissionPercentage': commissionPercentage,
        'traderCommissionPercentage': traderCommissionPercentage,
        'officeCommissionPercentage': officeCommissionPercentage,
        'brokerCommissionPercentage': brokerCommissionPercentage,
        'pieceFees': pieceFees,
        'traderPiecePercentage': traderPiecePercentage,
        'workerPiecePercentage': workerPiecePercentage,
        'officePiecePercentage': officePiecePercentage,
        'brokerPiecePercentage': brokerPiecePercentage,
      },
    );
    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to add material to sale process');
    }
  }

  Future<void> deleteSellMaterial({
    required int materialId,
    required String materialType,
  }) async {
    final response = await _apiService.delete(
      '${ApiConstants.deleteMaterial}?materialId=$materialId&materialType=$materialType',
    );
    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to delete sell material');
    }
  }
}
