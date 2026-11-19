import 'package:flutter/material.dart';
import '../api/todo_api.dart';
import '../models/todo.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoApi _api = TodoApi();
  final List<Todo> _todos = [];
  final List<String> _retryLogs = [];
  final TextEditingController _textController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _verifyEquatable();
    _loadTodos('/todos');
  }

  void _verifyEquatable() {
    const a = Todo(userId: 1, id: 1, title: 'delectus aut autem', completed: false);
    const b = Todo(userId: 1, id: 1, title: 'delectus aut autem', completed: false);
    debugPrint('Task I Equatable check (a == b): ${a == b}');
  }

  Future<void> _loadTodos(String path) async {
    setState(() {
      _isLoading = true;
      _retryLogs.clear();
      _retryLogs.add('Requesting GET $path ...');
    });

    try {
      final fetched = await _api.fetchTodos(
        path: path,
        onRetryLog: (msg) {
          if (!mounted) return;
          setState(() {
            _retryLogs.add(msg);
          });
        },
      );

      if (!mounted) return;
      setState(() {
        _todos
          ..clear()
          ..addAll(fetched);
        _retryLogs.add('Success: Loaded ${fetched.length} todos.');
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _retryLogs.add('Request terminated with error.');
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _todos.insert(
          0,
          Todo(
            userId: 1,
            id: DateTime.now().millisecondsSinceEpoch,
            title: text,
            completed: false,
          ),
        );
      });
      _textController.clear();
    }
  }

  void _toggleTodo(int index, bool? value) {
    setState(() {
      _todos[index] = _todos[index].copyWith(completed: value ?? false);
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
        title: const Text('Todo List - Lab 4'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : () => _loadTodos('/todos'),
            icon: const Icon(Icons.refresh),
            label: const Text('/todos'),
          ),
          TextButton.icon(
            onPressed: _isLoading ? null : () => _loadTodos('/nope'),
            icon: const Icon(Icons.warning_amber, color: Colors.orange),
            label: const Text('Test /nope'),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_retryLogs.isNotEmpty)
            Container(
              width: double.infinity,
              color: Colors.grey.shade900,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Network & Retry Log:',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ..._retryLogs.map(
                    (log) => Text(
                      log,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];

                return Dismissible(
                  key: ValueKey(todo.id),
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
                    onChanged: (value) => _toggleTodo(index, value),
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
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('ID: ${todo.id} • User: ${todo.userId}'),
        value: todo.completed,
        onChanged: onChanged,
      ),
    );
  }
}