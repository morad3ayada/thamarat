import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';

class OfficeRepository {
  final ApiService _apiService;

  OfficeRepository(this._apiService);

  Future<Map<String, dynamic>> getOfficeInfo() async {
    print('[OFFICE] Fetching office info from: ${ApiConstants.baseUrl}${ApiConstants.officeInfo}');
    final response = await _apiService.get(ApiConstants.officeInfo);
    print('[OFFICE] Response: ${response.data}');
    
    // The response is already the data we need, no need to check for success
    return response.data;
  }
} 