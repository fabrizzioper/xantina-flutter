import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infra/datasources/task_api.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskApi();
});

final tasksAssignedToMeProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasksAssignedToMe();
});

final tasksAssignedByMeProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasksAssignedByMe();
});
