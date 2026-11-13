import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

class NoteRepository {
  static const String _metadataKey = 'notes_metadata';
  final SecureStorageService _secureStorage;

  NoteRepository({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? metadataJson = prefs.getString(_metadataKey);

    if (metadataJson == null || metadataJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(metadataJson);
      final List<Note> notes = [];

      for (final item in decoded) {
        final id = item['id'] as String;
        final title = item['title'] as String;
        final createdAt = DateTime.tryParse(item['createdAt'] as String) ?? DateTime.now();
        final content = await _secureStorage.getContent(id) ?? '';

        notes.add(Note(
          id: id,
          title: title,
          content: content,
          createdAt: createdAt,
        ));
      }

      debugPrint('Fetched ${notes.length} notes metadata successfully');
      return notes;
    } catch (e) {
      debugPrint('Error retrieving notes metadata: $e');
      return [];
    }
  }

  Future<void> saveNote(Note note) async {
    await _secureStorage.saveContent(note.id, note.content);

    final prefs = await SharedPreferences.getInstance();
    final String? metadataJson = prefs.getString(_metadataKey);
    List<dynamic> list = [];

    if (metadataJson != null && metadataJson.isNotEmpty) {
      try {
        list = jsonDecode(metadataJson);
      } catch (_) {
        list = [];
      }
    }

    final metadata = {
      'id': note.id,
      'title': note.title,
      'createdAt': note.createdAt.toIso8601String(),
    };

    final existingIndex = list.indexWhere((item) => item['id'] == note.id);
    if (existingIndex >= 0) {
      list[existingIndex] = metadata;
    } else {
      list.add(metadata);
    }

    await prefs.setString(_metadataKey, jsonEncode(list));
    debugPrint('Note metadata saved for id: ${note.id}');
  }

  Future<void> deleteNote(String noteId) async {
    await _secureStorage.deleteContent(noteId);

    final prefs = await SharedPreferences.getInstance();
    final String? metadataJson = prefs.getString(_metadataKey);

    if (metadataJson != null && metadataJson.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(metadataJson);
        final updatedList = list.where((item) => item['id'] != noteId).toList();
        await prefs.setString(_metadataKey, jsonEncode(updatedList));
      } catch (_) {}
    }

    debugPrint('Note deleted for id: $noteId');
  }
}
