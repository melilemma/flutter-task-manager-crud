import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/todo_model.dart';
import '../bloc/todo_bloc.dart';
import 'add_edit_todo_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  Future<void> _openAddPage(BuildContext context) async {
    final TodoModel? todo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditTodoPage(),
      ),
    );

    if (todo != null && context.mounted) {
      context.read<TodoBloc>().add(AddTodoEvent(todo));
    }
    }

  Future<void> _openEditPage(BuildContext context, TodoModel todo) async {
    final TodoModel? updatedTodo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditTodoPage(todo: todo),
      ),
    );

    if (updatedTodo != null && context.mounted) {
      context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
    }
  }

  void _deleteTodo(BuildContext context, int id) {
    context.read<TodoBloc>().add(DeleteTodoEvent(id));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddPage(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TodoBloc>().add(LoadTodos());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TodoLoaded) {
             if (state.todos.isEmpty) {
              return const Center(
                child: Text('No tasks found'),
              );
            }

            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];

                return Dismissible(
                  key: Key(todo.id?.toString() ?? index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) {
                    if (todo.id != null) {
                      _deleteTodo(context, todo.id!);
                    }
                  },
                  child: Card(
  elevation: 3,
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: ListTile(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    leading: Icon(
      todo.completed
          ? Icons.check_circle
          : Icons.radio_button_unchecked,
      color: todo.completed ? Colors.green : Colors.orange,
      size: 30,
    ),
    title: Text(
      todo.title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
    subtitle: Text(
      todo.completed ? 'Completed' : 'Pending',
      style: TextStyle(
        color: todo.completed ? Colors.green : Colors.orange,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.edit,
        color: Colors.teal,
      ),
    ),
    onTap: () => _openEditPage(context, todo),
  ),
),
                );
              },
            );
          }


          return const SizedBox();
        },
      ),
    );
  }
}
