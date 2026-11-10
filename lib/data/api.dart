import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_assistant/domain/globals.dart';

// Адрес сервера по умолчанию. Его можно поменять без пересборки в файле config.json
// (поле "apiUrl") или при сборке: --dart-define=API_URL=https://...
const String _defaultApiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000');

// Ошибка запроса к серверу с понятным для пользователя текстом
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

// Нейросеть, с которой можно общаться
class AiModel {
  final String key;
  final String title;
  AiModel(this.key, this.title);
}

// Сообщение в чате
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, this.isUser);
}

// Клиент серверной части
class Api {
  static String _baseUrl = _defaultApiUrl;
  static String? _token;

  // Читает адрес сервера из config.json (лежит рядом с index.html)
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    try {
      final resp = await http.get(Uri.base.resolve('config.json')).timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) {
        final url = (jsonDecode(utf8.decode(resp.bodyBytes))['apiUrl'] ?? '').toString().trim();
        if (url.isNotEmpty) _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
      }
    } catch (_) {
      // config.json нет или он повреждён — остаёмся на адресе по умолчанию
    }
    if (kDebugMode) debugPrint('API: $_baseUrl');
  }

  static bool get hasToken => _token != null;

  static Future<dynamic> _request(String method, String path, {Map<String, dynamic>? body, Duration timeout = const Duration(seconds: 30)}) async {
    final headers = {'Content-Type': 'application/json; charset=utf-8', if (_token != null) 'Authorization': 'Bearer $_token'};
    final uri = Uri.parse('$_baseUrl$path');
    late http.Response resp;
    try {
      final payload = body == null ? null : jsonEncode(body);
      switch (method) {
        case 'POST':
          resp = await http.post(uri, headers: headers, body: payload).timeout(timeout);
        case 'PATCH':
          resp = await http.patch(uri, headers: headers, body: payload).timeout(timeout);
        case 'DELETE':
          resp = await http.delete(uri, headers: headers).timeout(timeout);
        default:
          resp = await http.get(uri, headers: headers).timeout(timeout);
      }
    } catch (_) {
      throw ApiException('Не удаётся связаться с сервером. Проверьте интернет и попробуйте ещё раз');
    }

    dynamic data;
    try {
      data = jsonDecode(utf8.decode(resp.bodyBytes));
    } catch (_) {
      data = null;
    }
    if (resp.statusCode >= 200 && resp.statusCode < 300) return data;

    if (resp.statusCode == 401 && _token != null) {
      await _saveToken(null); // токен устарел
    }
    final detail = data is Map ? data['detail'] : null;
    throw ApiException(detail is String ? detail : (resp.statusCode == 422 ? 'Проверьте введённые данные' : 'Ошибка сервера (${resp.statusCode})'));
  }

  static Future<void> _saveToken(String? token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove('token');
    } else {
      await prefs.setString('token', token);
    }
  }

  static void _applyUser(Map user) {
    userName = (user['name'] ?? '').toString();
    userTone = (user['tone'] ?? userTone).toString();
  }

  static Future<void> _authenticate(String path, Map<String, dynamic> body) async {
    final data = await _request('POST', path, body: body);
    await _saveToken(data['token']);
    _applyUser(data['user']);
  }

  static Future<void> register(String email, String password) => _authenticate('/api/auth/register', {'email': email, 'password': password});

  static Future<void> login(String email, String password) => _authenticate('/api/auth/login', {'email': email, 'password': password});

  // Пробует войти по сохранённому токену
  static Future<bool> restoreSession() async {
    if (_token == null) return false;
    try {
      _applyUser(await _request('GET', '/api/me', timeout: const Duration(seconds: 10)));
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> logout() async {
    await _saveToken(null);
    userName = '';
  }

  static Future<void> updateProfile({String? name, String? tone}) async {
    _applyUser(await _request('PATCH', '/api/me', body: {if (name != null) 'name': name, if (tone != null) 'tone': tone}));
  }

  static Future<List<AiModel>> models() async {
    final data = await _request('GET', '/api/models') as List;
    return data.map((m) => AiModel(m['key'], m['title'])).toList();
  }

  static Future<List<ChatMessage>> chat(String modelKey) async {
    final data = await _request('GET', '/api/chats/$modelKey') as List;
    return data.map((m) => ChatMessage(m['text'], m['isUser'])).toList();
  }

  // Отправляет сообщение и возвращает ответ нейросети
  static Future<ChatMessage> send(String modelKey, String text) async {
    final data = await _request('POST', '/api/chats/$modelKey/messages', body: {'text': text}, timeout: const Duration(seconds: 90));
    return ChatMessage(data['text'], false);
  }

  static Future<void> clearChat(String modelKey) => _request('DELETE', '/api/chats/$modelKey');
}
