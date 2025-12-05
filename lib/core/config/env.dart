import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_URL no está definida en las variables de entorno');
    }
    return url;
  }
  
  static Future<void> load() async {
    await dotenv.load(fileName: 'assets/.env');
  }
}
