import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/user_model.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiService _apiService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._apiService);

  Future<UserModel> login(String phone, String password) async {
    Response response = await _apiService.post(
      ApiConstants.login,
      data: {"phone": phone, "password": password},
    );

    final data = response.data; // ✅ لازم تفك .data

    if (data['success'] == true) {
      final user = UserModel.fromJson(data['data']);
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'user', value: user.toJson().toString());
      return user;
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
