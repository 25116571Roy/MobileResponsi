import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/note.dart';
import '../repositories/note_repository.dart';

class AppProvider extends InheritedWidget {
  final Student student;
  final List<Note> notes;
  final void Function(Student) updateStudent;
  final void Function(Note) addNote;
  final void Function(String) deleteNote;

  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  static AppProvider of(BuildContext context) {
    final AppProvider? result =
        context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(result != null, 'No AppProvider found in context');
    return result!;
  }

  static AppProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProvider>();
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student || notes != oldWidget.notes;
  }
}

class AppProviderWrapper extends StatefulWidget {
  final Widget child;
  final Student? initialStudent;
  final List<Note>? initialNotes;

  const AppProviderWrapper({
    super.key,
    required this.child,
    this.initialStudent,
    this.initialNotes,
  });

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _noteRepository = NoteRepository();
  late Student _student;
  late List<Note> _notes;

  @override
  void initState() {
    super.initState();
    _student = widget.initialStudent ??
        const Student(
          name: 'Roy Widyadhana Prastowo',
          nim: '25.11.6571',
          programStudi: 'S1 Informatika',
          email: 'r.widyadhana@students.amikom.ac.id',
        );
    _notes = widget.initialNotes ?? [];
    _loadNotesFromStorage();
  }

  Future<void> _loadNotesFromStorage() async {
    final storedNotes = await _noteRepository.getNotes();
    if (storedNotes.isNotEmpty && mounted) {
      setState(() {
        _notes = storedNotes;
      });
    }
  }

  void _updateStudent(Student newStudent) {
    setState(() {
      _student = newStudent;
    });
  }

  void _addNote(Note note) {
    setState(() {
      _notes = [..._notes, note];
    });
    _noteRepository.saveNote(note);
  }

  void _deleteNote(String id) {
    setState(() {
      _notes = _notes.where((note) => note.id != id).toList();
    });
    _noteRepository.deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}
