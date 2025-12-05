import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/business_chat_repository.dart';

class BusinessChatApi implements BusinessChatRepository {
  final Dio _dio = DioClient.getInstance();

  @override
  Future<List<BusinessChatMessage>> getBusinessChatMessages(
      String businessId) async {
    try {
      final response = await _dio.get('/chat/business/$businessId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) {
        final map = json as Map<String, dynamic>;
        return BusinessChatMessage(
          id: map['id'] as String,
          businessId: map['businessId'] as String,
          senderId: map['senderId'] as String,
          message: map['message'] as String,
          senderName: map['senderName'] as String?,
          likes: map['likes'] as int,
          dislikes: map['dislikes'] as int,
          createdAt: DateTime.parse(map['createdAt'] as String),
          updatedAt: DateTime.parse(map['updatedAt'] as String),
        );
      }).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al obtener mensajes del chat';
        
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
  Future<BusinessChatMessage> sendBusinessChatMessage({
    required String businessId,
    required String message,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/business/$businessId',
        data: {'message': message},
      );
      
      final map = response.data as Map<String, dynamic>;
      return BusinessChatMessage(
        id: map['id'] as String,
        businessId: map['businessId'] as String,
        senderId: map['senderId'] as String,
        message: map['message'] as String,
        senderName: map['senderName'] as String?,
        likes: map['likes'] as int,
        dislikes: map['dislikes'] as int,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al enviar el mensaje';
        
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
  Future<BusinessChatMessage> reactToMessage({
    required String messageId,
    required String reaction,
  }) async {
    try {
      final response = await _dio.patch(
        '/chat/business/message/$messageId/react',
        data: {'reaction': reaction},
      );
      
      final map = response.data as Map<String, dynamic>;
      return BusinessChatMessage(
        id: map['id'] as String,
        businessId: map['businessId'] as String,
        senderId: map['senderId'] as String,
        message: map['message'] as String,
        senderName: map['senderName'] as String?,
        likes: map['likes'] as int,
        dislikes: map['dislikes'] as int,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al reaccionar al mensaje';
        
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
