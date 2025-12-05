import 'package:dio/dio.dart';
import '../config/env.dart';
import 'interceptors.dart';

class DioClient {
  static Dio? _instance;
  
  static Dio getInstance() {
    _instance ??= Dio(
      BaseOptions(
        baseUrl: Env.apiUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _instance!.interceptors.add(AuthInterceptor());
    
    return _instance!;
  }
}
