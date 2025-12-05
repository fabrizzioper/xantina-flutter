import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';
import '../../domain/repositories/user_auth_repository.dart';
import '../../domain/entities/app_user.dart';

class UserAuthApi implements UserAuthRepository {
  final Dio _dio = DioClient.getInstance();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/user-auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final userData = data['user'] as Map<String, dynamic>;
      
      return AuthResponse(
        accessToken: data['access_token'] as String,
        user: UserModel.fromJson(userData),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al iniciar sesión';
        
        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'];
          if (message is List && message.isNotEmpty) {
            // Si hay múltiples mensajes, los unimos con saltos de línea
            errorMessage = message.map((m) => m.toString()).join('\n');
          } else if (message is String) {
            errorMessage = message;
          }
        }
        
        throw Exception(errorMessage);
      }
      throw Exception('Error de conexión. Verifica tu internet');
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    String? image,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
      };
      
      if (image != null && image.isNotEmpty) {
        requestData['image'] = image;
      }

      final response = await _dio.post(
        '/user-auth/register',
        data: requestData,
      );

      final data = response.data as Map<String, dynamic>;
      final userData = data['user'] as Map<String, dynamic>;
      
      return AuthResponse(
        accessToken: data['access_token'] as String,
        user: UserModel.fromJson(userData),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al registrar usuario';
        
        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'];
          if (message is List && message.isNotEmpty) {
            // Si hay múltiples mensajes, los unimos con saltos de línea
            errorMessage = message.map((m) => m.toString()).join('\n');
          } else if (message is String) {
            errorMessage = message;
          }
        }
        
        throw Exception(errorMessage);
      }
      throw Exception('Error de conexión. Verifica tu internet');
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<AppUser> updateProfile({
    String? name,
    String? email,
    String? image,
  }) async {
    try {
      final requestData = <String, dynamic>{};
      
      if (name != null) {
        requestData['name'] = name;
      }
      
      if (email != null) {
        requestData['email'] = email;
      }
      
      if (image != null) {
        requestData['image'] = image;
      }

      final response = await _dio.put(
        '/user-auth/profile',
        data: requestData,
      );

      final userData = response.data as Map<String, dynamic>;
      
      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al actualizar perfil';
        
        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'];
          if (message is List && message.isNotEmpty) {
            errorMessage = message.map((m) => m.toString()).join('\n');
          } else if (message is String) {
            errorMessage = message;
          }
        }
        
        throw Exception(errorMessage);
      }
      throw Exception('Error de conexión. Verifica tu internet');
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }
}
