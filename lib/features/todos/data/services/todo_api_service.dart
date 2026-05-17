import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';
import '../models/todo_model.dart';

class TodoApiService {
  final Dio _dio = DioClient.dio;

  // READ - Fetch todos from the API
  // We replace the original Latin placeholder titles with "Task 1", "Task 2", etc.
  Future<List<TodoModel>> fetchTodos() async {
    final response = await _dio.get('/todos?_limit=20');

    return (response.data as List)
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key + 1;
          final json = entry.value;

          return TodoModel(
            id: json['id'],
            title: 'Task $index',
            completed: json['completed'] ?? false,
          );
        })
        .toList();
  }

  // CREATE - Add a new todo
  Future<TodoModel> createTodo(TodoModel todo) async {
    final response = await _dio.post(
      '/todos',
      data: todo.toJson(),
    );

    return TodoModel.fromJson(response.data);
  }

  // UPDATE - Edit an existing todo
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final response = await _dio.put(
      '/todos/${todo.id}',
      data: todo.toJson(),
    );

    return TodoModel.fromJson(response.data);
  }

  // DELETE - Remove a todo
  Future<void> deleteTodo(int id) async {
    await _dio.delete('/todos/$id');
  }
}
