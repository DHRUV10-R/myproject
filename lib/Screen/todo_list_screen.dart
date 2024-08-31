import 'package:flutter/material.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final List<ToDoItem> _toDoItems = [];
  final TextEditingController _textController = TextEditingController();

  void _addToDoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _toDoItems.add(ToDoItem(task));
      });
      _textController.clear();
    }
  }

  void _toggleToDoItem(int index) {
    setState(() {
      _toDoItems[index].toggleComplete();
    });
  }

  void _removeToDoItem(int index) {
    setState(() {
      _toDoItems.removeAt(index);
    });
  }

  Widget _buildToDoItem(ToDoItem item, int index) {
    return ListTile(
      title: Text(
        item.task,
        style: TextStyle(
          decoration: item.isComplete ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: item.isComplete,
        onChanged: (_) => _toggleToDoItem(index),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _removeToDoItem(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter a task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addToDoItem(_textController.text),
                ),
              ),
              onSubmitted: _addToDoItem,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _toDoItems.length,
              itemBuilder: (context, index) {
                return _buildToDoItem(_toDoItems[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ToDoItem {
  String task;
  bool isComplete;

  ToDoItem(this.task) : isComplete = false;

  void toggleComplete() {
    isComplete = !isComplete;
  }
}
