import '../entities/task.dart';

abstract class TaskRepository {
  Future<Task> createTask({
    required String title,
    required String description,
    required String businessId,
    required String assignedToUserId,
    List<String>? images,
  });

  Future<List<Task>> getTasksByBusiness(String businessId);
  Future<List<Task>> getTasksAssignedToMe();
  Future<List<Task>> getTasksAssignedByMe();
  Future<Task> updateTaskStatus(
    String taskId,
    String status, // 'pending', 'in_progress', 'completed'
  );
  Future<void> deleteTask(String taskId);
}
