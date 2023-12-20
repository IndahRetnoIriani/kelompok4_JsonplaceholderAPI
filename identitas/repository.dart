import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_4/model/model.dart';

class TodoApi {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch todos');
    }
  }

  Future<void> deleteTodo(int id, List<Todo> todos, Function setState) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      print('Todo deleted successfully');
      // Hapus todo dengan ID yang sesuai dari daftar
      todos.removeWhere((todo) => todo.id == id);
      setState();
    } else {
      throw Exception(
          'Failed to delete todo. Status code: ${response.statusCode}');
    }
  }

  Future<Todo> createTodo(
      String title, List<Todo> todos, Function setState) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({'title': title}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      final newTodo = Todo(data['id'], data['title']);
      todos.add(newTodo);
      setState();
      return newTodo;
    } else {
      throw Exception(
          'Failed to create todo. Status code: ${response.statusCode}');
    }
  }

  Future<Todo> updateTodoApi(
      int id, String newTitle, List<Todo> todos, Function setState) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      body: jsonEncode({'title': newTitle}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final updatedTodo = Todo(data['id'], data['title']);
      final index = todos.indexWhere((todo) => todo.id == id);
      todos[index] = updatedTodo;
      setState();
      return updatedTodo;
    } else {
      throw Exception(
          'Failed to update todo. Status code: ${response.statusCode}');
    }
  }
}
