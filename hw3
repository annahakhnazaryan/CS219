import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudyScoreApp());
}

class StudyScoreApp extends StatelessWidget {
  const StudyScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Score Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      home: const ScoreDashboard(),
    );
  }
}

class Task {
  final int id;
  double mark;
  Task(this.id, this.mark);

  Map<String, dynamic> toJson() => {'id': id, 'mark': mark};
  static Task fromJson(Map<String, dynamic> json) =>
      Task(json['id'], (json['mark'] as num).toDouble());
}

class ScoreDashboard extends StatefulWidget {
  const ScoreDashboard({super.key});
  @override
  State<ScoreDashboard> createState() => _ScoreDashboardState();
}

class _ScoreDashboardState extends State<ScoreDashboard> {
  static const String _tKey = 'tasks';
  static const String _nextIdKey = 'nextTaskId';
  static const String _maxKey = 'maxTasks';
  static const String _mid1Key = 'm1';
  static const String _mid2Key = 'm2';
  static const String _partKey = 'participation';
  static const String _groupKey = 'group';
  static const String _projKey = 'project';
  static const String _finalKey = 'finalScore';

  List<Task> taskList = [];
  int _nextTaskId = 0;
  int _maxTasks = 0;
  final int _taskCap = 8;

  double m1 = 100, m2 = 100, part = 100, group = 100, proj = 100, result = 100;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _m1Controller = TextEditingController();
  final TextEditingController _m2Controller = TextEditingController();
  final TextEditingController _partController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _projController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      m1 = prefs.getDouble(_mid1Key) ?? 100;
      m2 = prefs.getDouble(_mid2Key) ?? 100;
      part = prefs.getDouble(_partKey) ?? 100;
      group = prefs.getDouble(_groupKey) ?? 100;
      proj = prefs.getDouble(_projKey) ?? 100;
      result = prefs.getDouble(_finalKey) ?? 100;
      _nextTaskId = prefs.getInt(_nextIdKey) ?? 0;
      _maxTasks = prefs.getInt(_maxKey) ?? 0;
      final storedTasks = prefs.getStringList(_tKey);
      if (storedTasks != null) {
        taskList = storedTasks.map((e) => Task.fromJson(jsonDecode(e))).toList();
      }
      _m1Controller.text = m1.toStringAsFixed(0);
      _m2Controller.text = m2.toStringAsFixed(0);
      _partController.text = part.toStringAsFixed(0);
      _groupController.text = group.toStringAsFixed(0);
      _projController.text = proj.toStringAsFixed(0);
    });
    _updateScore(false);
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksAsString = taskList.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_tKey, tasksAsString);
    await prefs.setInt(_nextIdKey, _nextTaskId);
    await prefs.setInt(_maxKey, _maxTasks);
    await prefs.setDouble(_mid1Key, m1);
    await prefs.setDouble(_mid2Key, m2);
    await prefs.setDouble(_partKey, part);
    await prefs.setDouble(_groupKey, group);
    await prefs.setDouble(_projKey, proj);
    await prefs.setDouble(_finalKey, result);
  }

  void _updateScore([bool rebuild = true]) {
    double avgTask = taskList.isEmpty
        ? 100
        : taskList.map((t) => t.mark).reduce((a, b) => a + b) / taskList.length;
    double newRes = (avgTask * 0.20) +
        (m1 * 0.10) +
        (m2 * 0.20) +
        (part * 0.10) +
        (group * 0.10) +
        (proj * 0.30);
    if (rebuild) {
      setState(() => result = newRes);
    } else {
      result = newRes;
    }
    _savePrefs();
  }

  void _addTask() {
    if (_taskController.text.isEmpty) return;
    if (_maxTasks >= _taskCap) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Task limit reached')));
      return;
    }
    final val = double.tryParse(_taskController.text);
    if (val != null && val >= 0 && val <= 100) {
      setState(() {
        taskList.add(Task(_nextTaskId++, val));
        _maxTasks++;
        _updateScore(false);

      });
      _taskController.clear();
      _savePrefs();
    }
  }

  void _resetAll() {
    setState(() {
      taskList.clear();
      _maxTasks = 0;
      _nextTaskId = 0;
      m1 = m2 = part = group = proj = 100;
      result = 100;
      _taskController.clear();
      _m1Controller.text =
          _m2Controller.text = _partController.text = _groupController.text = _projController.text = '100';
    });
    _savePrefs();
  }

  Widget _numField(String label, TextEditingController c, Function(double) onChanged) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onChanged: (v) {
        final val = double.tryParse(v);
        if (val != null && val >= 0 && val <= 100) {
          onChanged(val);
          _updateScore(false);
          _savePrefs();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Score Tracker'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        child: _numField('Enter Task Score (0–100)', _taskController, (double _) {}),
                      ),
                      const SizedBox(width: 10),
                      FloatingActionButton.small(
                        backgroundColor: Colors.pinkAccent,
                        onPressed: _addTask,
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...taskList.asMap().entries.map((e) {
                    final t = e.value;
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text('Task ${e.key + 1}: ${t.mark.toStringAsFixed(0)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              taskList.remove(t);
                              _maxTasks = max(0, _maxTasks - 1);
                              _updateScore(false);

                            });
                            _savePrefs();
                          },
                        ),
                      ),
                    );
                  }),
                ]),
              ),
            ),
            _numField('Midterm 1', _m1Controller, (v) => m1 = v),
            const SizedBox(height: 10),
            _numField('Midterm 2', _m2Controller, (v) => m2 = v),
            const SizedBox(height: 10),
            _numField('Participation', _partController, (v) => part = v),
            const SizedBox(height: 10),
            _numField('Group Work', _groupController, (v) => group = v),
            const SizedBox(height: 10),
            _numField('Project', _projController, (v) => proj = v),
            const SizedBox(height: 25),
            Center(
              child: Text(
                'Total Score: ${result.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _updateScore(true),
              icon: const Icon(Icons.calculate),
              label: const Text('Recalculate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _resetAll,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Everything'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
