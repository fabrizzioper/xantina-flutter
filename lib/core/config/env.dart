import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000/api';
  
  static Future<void> load() async {
    await dotenv.load(fileName: 'assets/.env');
  }
}
