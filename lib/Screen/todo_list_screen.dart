import 'package:flutter/material.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final List<ToDoItem> _toDoItems = [];
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _addToDoItem(String task, String priority) {
    if (task.isNotEmpty) {
      setState(() {
        _toDoItems.add(ToDoItem(task, priority));
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
    final removedItem = _toDoItems[index];
    setState(() {
      _toDoItems.removeAt(index);
    });

    // Show an undo option after deleting an item
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task '${removedItem.task}' removed"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _toDoItems.insert(index, removedItem);
            });
          },
        ),
      ),
    );
  }

  Widget _buildToDoItem(ToDoItem item, int index) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text(
          item.task,
          style: TextStyle(
            decoration: item.isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('Priority: ${item.priority}'),
        leading: Checkbox(
          value: item.isComplete,
          onChanged: (_) => _toggleToDoItem(index),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeToDoItem(index),
        ),
      ),
    );
  }

  Future<void> _showAddTaskDialog() async {
    String newTask = '';
    String priority = 'Low'; // Default priority

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => newTask = value,
                decoration: InputDecoration(labelText: 'Task'),
              ),
              DropdownButton<String>(
                value: priority,
                onChanged: (String? newValue) {
                  setState(() {
                    priority = newValue!;
                  });
                },
                items: <String>['Low', 'Medium', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addToDoItem(newTask, priority);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddTaskDialog,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _toDoItems.isEmpty
                ? Center(
                    child: Text(
                      'No tasks yet!',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
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
  String priority;
  bool isComplete;

  ToDoItem(this.task, this.priority) : isComplete = false;

  void toggleComplete() {
    isComplete = !isComplete;
  }
}
