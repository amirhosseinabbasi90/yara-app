import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class TaskItem {
  String title;
  bool done;
  TaskItem({required this.title, this.done = false});

  Map<String, dynamic> toJson() => {'title': title, 'done': done};
  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      TaskItem(title: json['title'], done: json['done']);
}

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  List<TaskItem> _tasks = [];
  bool _loading = true;
  final _newTaskController = TextEditingController();

  static const _prefsKey = 'yara_tasks_v1';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      _tasks = decoded.map((e) => TaskItem.fromJson(e)).toList();
    }
    setState(() => _loading = false);
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  void _addTask() {
    final text = _newTaskController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.add(TaskItem(title: text));
      _newTaskController.clear();
    });
    _saveTasks();
  }

  void _toggleTask(int index) {
    setState(() => _tasks[index].done = !_tasks[index].done);
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() => _tasks.removeAt(index));
    _saveTasks();
  }

  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _tasks.where((t) => t.done).length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: YaraColors.bgSoft,
        appBar: AppBar(
          backgroundColor: YaraColors.bgSoft,
          elevation: 0,
          title: const Text('برنامه‌ریزی',
              style: TextStyle(
                  color: YaraColors.textDark, fontWeight: FontWeight.bold)),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _newTaskController,
                              textAlign: TextAlign.right,
                              onSubmitted: (_) => _addTask(),
                              decoration: InputDecoration(
                                hintText: 'کار جدید بنویس...',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: YaraColors.purple,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              onPressed: _addTask,
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_tasks.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$doneCount از ${_tasks.length} کار انجام شده',
                            style: TextStyle(
                                fontSize: 12.5, color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _tasks.isEmpty
                          ? Center(
                              child: Text('هنوز کاری اضافه نکردی',
                                  style: TextStyle(
                                      color: Colors.grey.shade500)),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 4),
                              itemCount: _tasks.length,
                              itemBuilder: (context, index) {
                                final task = _tasks[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => _deleteTask(index),
                                        icon: Icon(Icons.delete_outline,
                                            color: Colors.red.shade300,
                                            size: 20),
                                      ),
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            decoration: task.done
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: task.done
                                                ? Colors.grey
                                                : YaraColors.textDark,
                                          ),
                                        ),
                                      ),
                                      Checkbox(
                                        value: task.done,
                                        activeColor: YaraColors.purple,
                                        onChanged: (_) => _toggleTask(index),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
