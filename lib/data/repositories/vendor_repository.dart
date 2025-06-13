import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/vendor_model.dart';

class VendorRepository {
  final ApiService _apiService;

  VendorRepository(this._apiService);

  Future<List<VendorModel>> getVendors() async {
    final response = await _apiService.get('/api/vendors');
    final data = response.data;

    if (data['success'] == true) {
      return (data['data'] as List)
          .map((e) => VendorModel.fromJson(e))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch vendors');
    }
  }

  Future<List<VendorModel>> searchVendors(String query) async {
    final response = await _apiService.get('/api/vendors/search', queryParameters: {'q': query});
    final data = response.data;

    if (data['success'] == true) {
      return (data['data'] as List)
          .map((e) => VendorModel.fromJson(e))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to search vendors');
    }
  }

  Future<VendorModel> addVendor({
    required String name,
    required String phone,
    required String address,
  }) async {
    final response = await _apiService.post(
      '/api/vendors',
      data: {
        'name': name,
        'phone': phone,
        'location': address,
      },
    );
    final data = response.data;

    if (data['success'] == true) {
      return VendorModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to add vendor');
    }
  }

  Future<VendorModel> updateVendor({
    required String id,
    required String name,
    required String phone,
    required String address,
  }) async {
    final response = await _apiService.put(
      '/api/vendors/$id',
      data: {
        'name': name,
        'phone': phone,
        'location': address,
      },
    );
    final data = response.data;

    if (data['success'] == true) {
      return VendorModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to update vendor');
    }
  }

  Future<void> deleteVendor(String id) async {
    final response = await _apiService.delete('/api/vendors/$id');
    final data = response.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to delete vendor');
    }
  }

  Future<VendorModel> getVendorDetails(int id) async {
    final response = await _apiService.get('/api/vendors/$id');
    final data = response.data;

    if (data['success'] == true) {
      return VendorModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch vendor details');
    }
  }
}
