import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatApi implements ChatRepository {
  final Dio _dio = DioClient.getInstance();

  @override
  Future<List<ChatMessage>> getConversation(String otherUserId) async {
    try {
      final response = await _dio.get('/chat/conversation/$otherUserId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) {
        final map = json as Map<String, dynamic>;
        return ChatMessage(
          id: map['id'] as String,
          senderId: map['senderId'] as String,
          receiverId: map['receiverId'] as String,
          message: map['message'] as String,
          senderName: map['senderName'] as String?,
          receiverName: map['receiverName'] as String?,
          createdAt: DateTime.parse(map['createdAt'] as String),
          updatedAt: DateTime.parse(map['updatedAt'] as String),
        );
      }).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al obtener la conversación';
        
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
  Future<ChatMessage> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/message/$receiverId',
        data: {'message': message},
      );
      
      final map = response.data as Map<String, dynamic>;
      return ChatMessage(
        id: map['id'] as String,
        senderId: map['senderId'] as String,
        receiverId: map['receiverId'] as String,
        message: map['message'] as String,
        senderName: map['senderName'] as String?,
        receiverName: map['receiverName'] as String?,
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
}
