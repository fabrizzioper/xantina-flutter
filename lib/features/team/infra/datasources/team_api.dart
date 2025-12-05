import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import 'package:xantina/features/user-auth/domain/entities/app_user.dart';
import 'package:xantina/features/user-auth/infra/models/user_model.dart';
import '../../domain/repositories/team_repository.dart';

class TeamApi implements TeamRepository {
  final Dio _dio = DioClient.getInstance();

  @override
  Future<List<AppUser>> getTeamUsers() async {
    try {
      final response = await _dio.get('/team/users');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al obtener usuarios del equipo';
        
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

  @override
  Future<AppUser> createTeamUser({
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
        '/team/users',
        data: requestData,
      );

      final data = response.data as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al crear el usuario';
        
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
