import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/profile_cache.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thamarat/core/api/api_service.dart';

class AuthRepository {
  final ApiService _apiService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._apiService);

  Future<UserModel> login(String email, String password) async {
    final response = await _apiService.post(
      ApiConstants.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    final data = response.data;

    if (data['success'] == true) {
      final user = UserModel.fromJson(data['data']);
      
      // ✅ تخزين آمن بصيغة JSON
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
      
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

  Future<UserModel?> getSavedUser() async {
    final userData = await _storage.read(key: 'user');
    if (userData != null) {
      final json = jsonDecode(userData);
      return UserModel.fromJson(json);
    }
    return null;
  }
}
