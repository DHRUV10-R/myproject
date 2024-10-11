import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final List<ToDoItem> _toDoItems = [];
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadToDoItems();
  }

  Future<void> _loadToDoItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? toDoItemsJson = prefs.getString('toDoItems');

    if (toDoItemsJson != null) {
      final List<dynamic> decodedJson = json.decode(toDoItemsJson);
      setState(() {
        _toDoItems.addAll(decodedJson.map((item) => ToDoItem.fromJson(item)).toList());
      });
    }
  }

  Future<void> _saveToDoItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_toDoItems.map((item) => item.toJson()).toList());
    await prefs.setString('toDoItems', encodedData);
  }

  void _addToDoItem(String task, String priority) {
    if (task.isNotEmpty) {
      setState(() {
        _toDoItems.add(ToDoItem(task, priority));
      });
      _textController.clear();
      _saveToDoItems(); // Save to persistent storage
    }
  }

  void _toggleToDoItem(int index) {
    setState(() {
      _toDoItems[index].toggleComplete();
    });
    _saveToDoItems(); // Save updated list
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
            _saveToDoItems(); // Save updated list
          },
        ),
      ),
    );
    _saveToDoItems(); // Save updated list after removal
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
      backgroundColor: Colors.green,
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

  // Convert ToDoItem to JSON format
  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'priority': priority,
      'isComplete': isComplete,
    };
  }

  // Create ToDoItem from JSON format
  factory ToDoItem.fromJson(Map<String, dynamic> json) {
    return ToDoItem(json['task'], json['priority'])
      ..isComplete = json['isComplete'];
  }
}
