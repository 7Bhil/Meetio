import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  /// API base URL. Prefer `API_BASE_URL` in `.env` (e.g. http://10.0.2.2:8000/api)
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api';
}
