import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('[AUTH] Bearer $token');
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print('[DIO ERROR] ${e.response?.statusCode} → ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      print('[GET ERROR] ${e.type} - ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('انتهت مهلة الاتصال. يرجى التحقق من الاتصال بالإنترنت');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('فشل في الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت');
      } else if (e.response?.statusCode == 401) {
        throw Exception('انتهت صلاحية الجلسة. يرجى إعادة تسجيل الدخول');
      } else if (e.response?.statusCode == 404) {
        throw Exception('المورد المطلوب غير موجود');
      } else if (e.response?.statusCode == 500) {
        throw Exception('خطأ في الخادم. يرجى المحاولة لاحقاً');
      }
      throw Exception('حدث خطأ في الاتصال: ${e.message}');
    } catch (e) {
      print('[GET ERROR] $e');
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      print('[POST ERROR] ${e.type} - ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('انتهت مهلة الاتصال. يرجى التحقق من الاتصال بالإنترنت');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('فشل في الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت');
      } else if (e.response?.statusCode == 401) {
        throw Exception('انتهت صلاحية الجلسة. يرجى إعادة تسجيل الدخول');
      } else if (e.response?.statusCode == 404) {
        throw Exception('المورد المطلوب غير موجود');
      } else if (e.response?.statusCode == 500) {
        throw Exception('خطأ في الخادم. يرجى المحاولة لاحقاً');
      }
      throw Exception('حدث خطأ في الاتصال: ${e.message}');
    } catch (e) {
      print('[POST ERROR] $e');
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      print('[PUT ERROR] ${e.type} - ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('انتهت مهلة الاتصال. يرجى التحقق من الاتصال بالإنترنت');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('فشل في الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت');
      } else if (e.response?.statusCode == 401) {
        throw Exception('انتهت صلاحية الجلسة. يرجى إعادة تسجيل الدخول');
      } else if (e.response?.statusCode == 404) {
        throw Exception('المورد المطلوب غير موجود');
      } else if (e.response?.statusCode == 500) {
        throw Exception('خطأ في الخادم. يرجى المحاولة لاحقاً');
      }
      throw Exception('حدث خطأ في الاتصال: ${e.message}');
    } catch (e) {
      print('[PUT ERROR] $e');
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      print('[DELETE ERROR] ${e.type} - ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('انتهت مهلة الاتصال. يرجى التحقق من الاتصال بالإنترنت');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('فشل في الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت');
      } else if (e.response?.statusCode == 401) {
        throw Exception('انتهت صلاحية الجلسة. يرجى إعادة تسجيل الدخول');
      } else if (e.response?.statusCode == 404) {
        throw Exception('المورد المطلوب غير موجود');
      } else if (e.response?.statusCode == 500) {
        throw Exception('خطأ في الخادم. يرجى المحاولة لاحقاً');
      }
      throw Exception('حدث خطأ في الاتصال: ${e.message}');
    } catch (e) {
      print('[DELETE ERROR] $e');
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }
}
