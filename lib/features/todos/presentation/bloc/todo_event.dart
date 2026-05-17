part of 'todo_bloc.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final TodoModel todo;

  AddTodoEvent(this.todo);
}

class UpdateTodoEvent extends TodoEvent {
  final TodoModel todo;

  UpdateTodoEvent(this.todo);
}

class DeleteTodoEvent extends TodoEvent {
  final int id;

  DeleteTodoEvent(this.id);
}
