import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const HomeworkApp());
}
class Homework {
  final String id;
  final String subject;
  final String title;
  final DateTime dueDate;
  final bool completed;

  Homework({
    required this.id,
    required this.subject,
    required this.title,
    required this.dueDate,
    this.completed = false,
  });

  Homework copyWith({
    String? id,
    String? subject,
    String? title,
    DateTime? dueDate,
    bool? completed,
  }) {
    return Homework(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
    );
  }
}

//uisng blocs
abstract class HomeworkEvent {}

class AddHomework extends HomeworkEvent {
  final Homework homework;
  AddHomework(this.homework);
}

class ToggleHomework extends HomeworkEvent {
  final String id;
  ToggleHomework(this.id);
}

//using blocs
class HomeworkState {
  final List<Homework> homeworks;
  const HomeworkState(this.homeworks);
}

//bloc
class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  HomeworkBloc() : super(const HomeworkState([])) {
    on<AddHomework>((event, emit) {
      final updated = List<Homework>.from(state.homeworks)..add(event.homework);
      emit(HomeworkState(updated));
    });

    on<ToggleHomework>((event, emit) {
      final updated = state.homeworks
          .map((h) => h.id == event.id
          ? h.copyWith(completed: !h.completed)
          : h)
          .toList();
      emit(HomeworkState(updated));
    });
  }
}


String formatDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String newId() => DateTime.now().toString();


class HomeworkApp extends StatelessWidget {
  const HomeworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeworkListPage(),
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) => const AddHomeworkPage(),
        ),
      ],
    );

    return BlocProvider(
      create: (_) => HomeworkBloc(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: 'Homework Tracker',
        theme: ThemeData(primarySwatch: Colors.indigo),
      ),
    );
  }
}


class HomeworkListPage extends StatelessWidget {
  const HomeworkListPage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homework Tracker')),
      body: BlocBuilder<HomeworkBloc, HomeworkState>(
        builder: (context, state) {
          if (state.homeworks.isEmpty) {
            return const Center(
              child: Text('No homework yet. Tap + to add.'),
            );
          }

          final sorted = List<Homework>.from(state.homeworks)
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

          return ListView.builder(
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final hw = sorted[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  title: Text(
                    hw.title,
                    style: TextStyle(
                      decoration: hw.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text('${hw.subject} • Due: ${formatDate(hw.dueDate)}'),
                  trailing: Checkbox(
                    value: hw.completed,
                    onChanged: (_) {
                      context.read<HomeworkBloc>().add(ToggleHomework(hw.id));
                    },
                  ),
                  onTap: () {
                    context.read<HomeworkBloc>().add(ToggleHomework(hw.id));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

//page 2
class AddHomeworkPage extends StatefulWidget {
  const AddHomeworkPage({super.key});

  State<AddHomeworkPage> createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  DateTime? _dueDate;

  void dispose() {
    _subjectCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final hw = Homework(
      id: newId(),
      subject: _subjectCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      dueDate: _dueDate ?? DateTime.now(),
    );

    context.read<HomeworkBloc>().add(AddHomework(hw));
    context.pop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Homework')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _subjectCtrl,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter subject' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Homework title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter homework title' : null,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _pickDate,
                child: Text(_dueDate == null
                    ? 'Due date'
                    : 'Due: ${formatDate(_dueDate!)}'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Save Homework'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
