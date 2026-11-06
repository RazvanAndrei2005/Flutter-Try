import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Todo> _todos = [];
  final TextEditingController _textController = TextEditingController();

  String? _filter;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _todos.add(
          Todo(
            identifier: DateTime.now().millisecondsSinceEpoch,
            title: text,
          ),
        );
      });
      _textController.clear();
    }
  }

  int _calculateCompletedCountBug1() {
    int completedCount = 0;
    for (var i = 0; i <= _todos.length; i++) {
      if (_todos[i].isDone) {
        completedCount++;
      }
    }
    return completedCount;
  }

  void _toggleTodoBug2(int index) {
    _todos[index].isDone = !_todos[index].isDone;
  }

  int _countMatchingFilterBug3() {
    final visible = _todos.where((t) => t.title.contains(_filter!));
    return visible.length;
  }

  void _toggleTodo(Todo todo, bool? value) {
    setState(() {
      todo.isDone = value ?? false;
    });
  }

  void _removeTodo(int index, Todo todo) {
    setState(() {
      _todos.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${todo.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _todos.insert(index, todo);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List - Lab 3'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              _calculateCompletedCountBug1();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Add a new task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTodo,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];

                return Dismissible(
                  key: ValueKey(todo.identifier),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _removeTodo(index, todo);
                  },
                  child: TodoTile(
                    todo: todo,
                    onChanged: (value) => _toggleTodo(todo, value),
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

class TodoTile extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: CheckboxListTile(
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        value: todo.isDone,
        onChanged: onChanged,
      ),
    );
  }
}