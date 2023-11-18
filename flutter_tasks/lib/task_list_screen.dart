import 'package:flutter/material.dart';
import 'package:flutter_tasks/task_creation_screen.dart';
import 'package:flutter_tasks/task_details_screen.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<ParseObject> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('Task'));
    final ParseResponse apiResponse = await queryBuilder.query();

    if (apiResponse.success && apiResponse.results != null) {
      setState(() {
        tasks = List<ParseObject>.from(apiResponse.results as Iterable);
      });
    } else {
      // Handle error
      print(apiResponse.error!.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.get<String>('title') ?? ''),
            subtitle: Text(task.get<String>('description') ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TaskDetailsScreen(task: tasks[index])),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskCreationScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
