import 'package:flutter/material.dart';
import 'package:flutter_application_4/identitas/repository.dart';
import 'package:flutter_application_4/model/model.dart';
import 'package:http/http.dart' as http;



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TodoApi todoApi = TodoApi();
  late List<Todo> todos;
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      todos = await todoApi.fetchTodos();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await todoApi.deleteTodo(id, todos, () {
        setState(() {});
      });
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  Future<void> createTodo() async {
    final String title = titleController.text;

    try {
      await todoApi.createTodo(title, todos, () {
        setState(() {});
      });
      titleController.clear();
    } catch (e) {
      print('Error creating todo: $e');
    }
  }

  void showUpdateTodoDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController updateController =
            TextEditingController(text: todo.title);

        return AlertDialog(
          title: Text('Update Todo'),
          content: TextField(
            controller: updateController,
            decoration: InputDecoration(
              labelText: 'Enter New Todo Title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await todoApi
                    .updateTodoApi(todo.id, updateController.text, todos, () {
                  setState(() {});
                });
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIB-3D Kelompok 4'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Input Todo Title',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: () async {
                await createTodo();
              },
              child: Text('Create'),
              ),
              ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                final color =
                    index % 2 == 0 ? Colors.blueGrey[200] : Colors.white;

                return Container(
                  color: color,
                  child: ListTile(
                    title: Text(todo.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await deleteTodo(todo.id);
                          },
                          child: Text('Delete'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            showUpdateTodoDialog(todo);
                          },
                          child: Text('Edit'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
