import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_formKey.currentState?.validate() ?? false) {
      final sanitizedTitle = Validators.sanitize(_titleController.text.trim());
      final sanitizedContent = Validators.sanitize(_contentController.text.trim());

      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: sanitizedTitle,
        content: sanitizedContent,
        createdAt: DateTime.now(),
      );

      final provider = AppProvider.maybeOf(context);
      if (provider != null) {
        provider.addNote(newNote);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan Kuliah'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Catatan',
                  hintText: 'Minimal 3 karakter, maksimal 50 karakter',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateTitle,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  hintText: 'Minimal 10 karakter, maksimal 1000 karakter',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Icon(Icons.description),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateContent,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveNote,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Catatan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
