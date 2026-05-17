 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/todos/data/repositories/todo_repository.dart';
import 'features/todos/data/services/todo_api_service.dart';
import 'features/todos/presentation/bloc/todo_bloc.dart';
import 'features/todos/presentation/pages/todo_list_page.dart';

void main() {
  final repository = TodoRepository(TodoApiService());

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TodoRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        useMaterial3: true,

        // Main app colors
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),

        // Background color
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),

        // AppBar style
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        // Floating Action Button style
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),

        // TextField style
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.teal,
              width: 2,
            ),
          ),
        ),

        // ElevatedButton style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // SnackBar style
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.teal,
          contentTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      home: Center(
        child: Container(
          width: 390,
          height: 844,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BlocProvider(
              create: (_) => TodoBloc(repository)..add(LoadTodos()),
              child: const TodoListPage(),
            ),
          ),
        ),
      ),
    );
  }
}