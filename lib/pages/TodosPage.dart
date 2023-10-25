import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latihan/model/todos.dart'; // Sesuaikan dengan nama proyek dan struktur folder Anda

class TodosPage extends StatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  late Future<Todos> _futureTodos;

  @override
  void initState() {
    super.initState();
    _futureTodos = fetchTodos();
  }

  Future<Todos> fetchTodos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/5'));
    if (response.statusCode == 200) {
      return Todos.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
      ),
      body: Center(
        child: FutureBuilder<Todos>(
          future: _futureTodos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('User ID: ${snapshot.data!.userId}'),
                  Text('ID: ${snapshot.data!.id}'),
                  Text('Title: ${snapshot.data!.title}'),
                  Text('Completed: ${snapshot.data!.completed}'),
                ],
              );
            } else {
              return Text('No data available.');
            }
          },
        ),
      ),
    );
  }
}
