import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static Future<void> init() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {}
  }

  static String get baseUrl {
    if (!dotenv.isInitialized) {
      return 'https://jsonplaceholder.typicode.com';
    }
    return dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';
  }

  static String get apiKey {
    if (!dotenv.isInitialized) {
      return '';
    }
    return dotenv.env['API_KEY'] ?? '';
  }
}
