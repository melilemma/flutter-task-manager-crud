import '../models/todo_model.dart';
import '../services/todo_api_service.dart';

class TodoRepository {
  final TodoApiService apiService;

  TodoRepository(this.apiService);

  Future<List<TodoModel>> getTodos() => apiService.fetchTodos();

  Future<TodoModel> addTodo(TodoModel todo) => apiService.createTodo(todo);

  Future<TodoModel> editTodo(TodoModel todo) => apiService.updateTodo(todo);

  Future<void> removeTodo(int id) => apiService.deleteTodo(id);
}
