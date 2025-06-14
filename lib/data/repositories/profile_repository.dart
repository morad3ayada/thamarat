import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/user_model.dart';

class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository(this._apiService);

  Future<UserModel> fetchProfile() async {
    final response = await _apiService.get(ApiConstants.profile);
    final data = response.data;

    if (data['success'] == true) {
      return UserModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch profile');
    }
  }

  Future<UserModel> updateProfile(UpdateProfileRequest request) async {
    final response = await _apiService.post(
      ApiConstants.editProfile,
      data: request.toJson(),
    );
    final data = response.data;

    if (data['success'] == true) {
      return UserModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to update profile');
    }
  }
}
