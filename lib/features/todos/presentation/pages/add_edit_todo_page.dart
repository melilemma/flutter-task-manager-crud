import 'package:flutter/material.dart';

import '../../data/models/todo_model.dart';

class AddEditTodoPage extends StatefulWidget {
  final TodoModel? todo;

  const AddEditTodoPage({super.key, this.todo});

  @override
  State<AddEditTodoPage> createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends State<AddEditTodoPage> {
  late TextEditingController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.todo?.title ?? '',
    );
    _completed = widget.todo?.completed ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_controller.text.trim().isEmpty) return;

    final todo = TodoModel(
      id: widget.todo?.id,
      title: _controller.text.trim(),
      completed: _completed,
    );

    Navigator.pop(context, todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _completed,
              title: const Text('Completed'),
              onChanged: (value) {
                setState(() {
                  _completed = value ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
      );
  }
}