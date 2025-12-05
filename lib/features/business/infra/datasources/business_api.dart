import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/business_model.dart';
import '../../domain/repositories/business_repository.dart';

class BusinessApi implements BusinessRepository {
  final Dio _dio = DioClient.getInstance();

  @override
  Future<List<BusinessModel>> getBusinesses() async {
    try {
      final response = await _dio.get('/business');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => BusinessModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al obtener negocios';
        
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
  Future<BusinessModel> getBusinessById(String id) async {
    try {
      final response = await _dio.get('/business/$id');
      final data = response.data as Map<String, dynamic>;
      return BusinessModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al obtener el negocio';
        
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
  Future<BusinessModel> createBusiness({
    required String name,
    required String type,
    required String phone,
    required String address,
    required String description,
    required String logo,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'name': name,
        'type': type,
        'phone': phone,
        'address': address,
        'description': description,
        'logo': logo,
      };

      final response = await _dio.post(
        '/business',
        data: requestData,
      );

      final data = response.data as Map<String, dynamic>;
      return BusinessModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al crear el negocio';
        
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
