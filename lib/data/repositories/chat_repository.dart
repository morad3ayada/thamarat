import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import '../models/chat_model.dart';

class ChatRepository {
  final ApiService _apiService;

  ChatRepository(this._apiService);

  Future<List<ChatMessage>> getMessages() async {
    try {
      final response = await _apiService.get(ApiConstants.chatMessages);
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        return data.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في جلب الرسائل');
      }
    } catch (e) {
      throw Exception('حدث خطأ في الاتصال: $e');
    }
  }

  Future<ChatMessage> sendMessage(String message) async {
    try {
      final response = await _apiService.post(
        ApiConstants.sendChatMessage,
        data: {'message': message},
      );

      if (response.data['success'] == true) {
        return ChatMessage.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'فشل في إرسال الرسالة');
      }
    } catch (e) {
      throw Exception('حدث خطأ في الاتصال: $e');
    }
  }
}
