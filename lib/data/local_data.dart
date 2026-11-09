import 'package:shared_preferences/shared_preferences.dart';

// Регистрация нового пользователя
Future<bool> registerUser(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(email)) {
    return false;
  }

  await prefs.setString(email, password);
  return true;
}

// Вход пользователя
Future<bool> loginUser(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey(email)) {
    return false;
  }

  String? savedPassword = prefs.getString(email);
  return savedPassword == password;
}

// Сохранить текущего пользователя
Future<void> setCurrentUser(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('currentUser', email);
}

// Получить текущего пользователя
Future<String?> getCurrentUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('currentUser');
}

// Выход из аккаунта
Future<void> logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('currentUser');
}
