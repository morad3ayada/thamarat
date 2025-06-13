import 'package:dio/dio.dart';
import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import '../models/chat_model.dart';

class ChatRepository {
  final ApiService _apiService;
  final Dio _dio;

  ChatRepository(this._apiService, this._dio);

  Future<List<ChatMessage>> getMessages() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/chat/messages');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception('فشل في جلب الرسائل');
      }
    } on DioException catch (e) {
      throw Exception('حدث خطأ في الاتصال');
    }
  }

  Future<ChatMessage> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/chat/messages',
        data: {'message': message},
      );

      if (response.statusCode == 201) {
        return ChatMessage.fromJson(response.data);
      } else {
        throw Exception('فشل في إرسال الرسالة');
      }
    } on DioException catch (e) {
      throw Exception('حدث خطأ في الاتصال');
    }
  }
}
