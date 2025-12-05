import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationApi implements NotificationRepository {
  final Dio _dio = DioClient.getInstance();

  @override
  Future<List<Notification>> getNotifications() async {
    try {
      final response = await _dio.get('/notifications');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) {
        final map = json as Map<String, dynamic>;
        return Notification(
          id: map['id'] as String,
          userId: map['userId'] as String,
          type: map['type'] as String,
          title: map['title'] as String,
          message: map['message'] as String,
          businessId: map['businessId'] as String?,
          senderId: map['senderId'] as String?,
          isRead: map['isRead'] as bool,
          createdAt: DateTime.parse(map['createdAt'] as String),
          updatedAt: DateTime.parse(map['updatedAt'] as String),
        );
      }).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al obtener notificaciones';
        
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
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get('/notifications/unread-count');
      final map = response.data as Map<String, dynamic>;
      return map['count'] as int;
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al obtener contador de notificaciones';
        
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
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.patch('/notifications/$notificationId/read');
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al marcar notificación como leída';
        
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
  Future<void> markAllAsRead() async {
    try {
      await _dio.patch('/notifications/read-all');
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al marcar todas como leídas';
        
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
