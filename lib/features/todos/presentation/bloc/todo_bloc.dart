import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/todo_model.dart';
import '../../data/repositories/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(
    LoadTodos event,
    Emitter<TodoState> emit,
    ) async {
    emit(TodoLoading());

    try {
      final todos = await repository.getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to load todos.')) ;
    }
  }

  Future<void> _onAddTodo(
    AddTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;

    final currentTodos = List<TodoModel>.from((state as TodoLoaded).todos);

try {
      final newTodo = await repository.addTodo(event.todo);
      emit(TodoLoaded([newTodo, ...currentTodos]));
    } catch (e) {
      emit(TodoError('Failed to add todo.'));
    }
  }

  Future<void> _onUpdateTodo(
    UpdateTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;

    final currentTodos = List<TodoModel>.from((state as TodoLoaded).todos);

    try {
      final updatedTodo = await repository.editTodo(event.todo);

final updatedList = currentTodos.map((todo) {
        return todo.id == updatedTodo.id ? updatedTodo : todo;
      }).toList();

      emit(TodoLoaded(updatedList));
    } catch (e) {
      emit(TodoError('Failed to update todo.'));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;

    final currentTodos = List<TodoModel>.from((state as TodoLoaded).todos);

try {
      await repository.removeTodo(event.id);

      currentTodos.removeWhere((todo) => todo.id == event.id);

      emit(TodoLoaded(currentTodos));
    } catch (e) {
      emit(TodoError('Failed to delete todo.'));
    }
  }
}
