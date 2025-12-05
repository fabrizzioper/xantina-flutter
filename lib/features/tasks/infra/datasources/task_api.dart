import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';

class TaskApi implements TaskRepository {
  final Dio _dio = DioClient.getInstance();

  @override
  Future<Task> createTask({
    required String title,
    required String description,
    required String businessId,
    required String assignedToUserId,
    List<String>? images,
  }) async {
    try {
      final response = await _dio.post(
        '/tasks',
        data: {
          'title': title,
          'description': description,
          'businessId': businessId,
          'assignedToUserId': assignedToUserId,
          'images': images ?? [],
        },
      );
      return Task.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        String errorMessage = 'Error al crear tarea';
        
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
  Future<List<Task>> getTasksByBusiness(String businessId) async {
    try {
      final response = await _dio.get('/tasks/business/$businessId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener tareas: ${e.message}');
    }
  }

  @override
  Future<List<Task>> getTasksAssignedToMe() async {
    try {
      final response = await _dio.get('/tasks/assigned-to-me');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener tareas: ${e.message}');
    }
  }

  @override
  Future<List<Task>> getTasksAssignedByMe() async {
    try {
      final response = await _dio.get('/tasks/assigned-by-me');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener tareas: ${e.message}');
    }
  }

  @override
  Future<Task> updateTaskStatus(String taskId, String status) async {
    try {
      final response = await _dio.put(
        '/tasks/$taskId/status',
        data: {'status': status},
      );
      return Task.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Error al actualizar tarea: ${e.message}');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _dio.delete('/tasks/$taskId');
    } on DioException catch (e) {
      throw Exception('Error al eliminar tarea: ${e.message}');
    }
  }
}
