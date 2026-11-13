import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  String _getKey(String noteId) => 'note_content_$noteId';

  Future<void> saveContent(String noteId, String content) async {
    await _storage.write(key: _getKey(noteId), value: content);
  }

  Future<String?> getContent(String noteId) async {
    return await _storage.read(key: _getKey(noteId));
  }

  Future<void> deleteContent(String noteId) async {
    await _storage.delete(key: _getKey(noteId));
  }
}
