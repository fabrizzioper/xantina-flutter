import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import 'package:xantina/features/user-auth/domain/entities/app_user.dart';
import 'package:xantina/features/user-auth/infra/models/user_model.dart';
import '../../domain/repositories/business_member_repository.dart';

class BusinessMemberApi implements BusinessMemberRepository {
  final Dio _dio = DioClient.getInstance();

  @override
  Future<List<AppUser>> getBusinessMembers(String businessId) async {
    try {
      final response = await _dio.get('/business/$businessId/members');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al obtener miembros del negocio';
        
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
  Future<List<AppUser>> addMembers({
    required String businessId,
    required List<String> userIds,
  }) async {
    try {
      final response = await _dio.post(
        '/business/$businessId/members',
        data: {
          'userIds': userIds,
        },
      );
      
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al agregar miembros';
        
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
