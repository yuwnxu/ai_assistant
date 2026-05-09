import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_assistant/presentation/mainScreens/auth/signIn.dart';
import 'package:ai_assistant/presentation/mainScreens/auth/register.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/home.dart';
import 'package:ai_assistant/presentation/mainScreens/mainPage.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/onBoarding.dart';

//Основные переменные и функции приложения

//Навигация

void navToSignIn(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignIn()));
  clearControllers();
  clearErrors();
}

void navToReg(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Register()));
  clearControllers();
  clearErrors();
}

void navToHome(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
  clearControllers();
  clearErrors();
}

void navToMain(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainPage()));
  clearControllers();
  clearErrors();
}

void navToBoard1(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OnBoarding1()));
  clearControllers();
  clearErrors();
}

void navToBoard2(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OnBoarding2()));
  clearControllers();
  clearErrors();
}

void navToBoard3(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OnBoarding3()));
  clearControllers();
  clearErrors();
}
//Контроллеры

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController = TextEditingController();

String? emailError;
String? passwordError;

String userName = '';

void clearControllers() {
  emailController.clear();
  passwordController.clear();
  nameController.clear();
}

void clearErrors() {
  emailError = null;
  passwordError = null;
}

// Регистрация и вход

// Регистрация нового пользователя
Future<bool> registerUser(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(email)) {
    return false; // Пользователь уже существует
  }

  await prefs.setString(email, password);
  return true;
}

// Вход пользователя
Future<bool> loginUser(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey(email)) {
    return false; // Пользователь не найден
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

//Чаты

List<String> aiNames = ['ChatGPT 5.1', 'Gemini 3.1 Pro', 'Claude Sonnet 4.6', 'DeepSeek V3', 'Grok 4'];

List<List<Map<String, dynamic>>> chatHistories = [
  // ChatGPT 5.1
  [
    {'text': 'Привет', 'isUser': true, 'width': 65},
    {'text': 'Привет! Рад тебя слышать! Как прошел твой день?', 'isUser': false, 'width': 325},
    {'text': 'Я очень устала на работе', 'isUser': true, 'width': 170},
    {
      'text':
          'Понимаю это состояние — когда хочется просто "выключиться". Вот несколько способов расслабиться:\n\n• Сними рабочую одежду сразу.\n• Теплый душ или ванна.\n• Правило 15 минут тишины.\n\nМой совет: поставь телефон на зарядку в другой комнате, выпей стакан воды и просто полежи 10 минут с закрытыми глазами.',
      'isUser': false,
      'width': 575,
    },
  ],
  // Gemini 3.1 Pro
  [],
  // Claude Sonnet 4.6
  [
    {'text': 'Не могу уснуть уже несколько ночей', 'isUser': true, 'width': 240},
    {'text': 'Бессонница — серьёзная проблема. Попробуй перед сном выпить тёплый чай.', 'isUser': false, 'width': 400},
    {'text': 'Я пробовала, не помогает', 'isUser': true, 'width': 200},
    {'text': 'Тогда рекомендую технику дыхания 4-7-8.', 'isUser': false, 'width': 350},
  ],
  // DeepSeek V3
  [
    {'text': 'Чувствую тревогу без причины', 'isUser': true, 'width': 210},
    {'text': 'Назови 5 предметов, которые ты видишь вокруг.', 'isUser': false, 'width': 380},
    {'text': '1. Ноутбук, 2. Кружка, 3. Окно, 4. Книга, 5. Ручка', 'isUser': true, 'width': 380},
    {'text': 'Отлично! Ты вернулся в реальность.', 'isUser': false, 'width': 280},
  ],
  // Grok 4
  [
    {'text': 'Я выгорела, ничего не хочется делать', 'isUser': true, 'width': 250},
    {'text': 'Выгорание — это не лень, а истощение. Отдохни 15 минут.', 'isUser': false, 'width': 380},
    {'text': 'У меня нет времени', 'isUser': true, 'width': 180},
    {'text': 'Даже 5 минут дыхания помогут. Дыши со мной: вдох... выдох...', 'isUser': false, 'width': 400},
  ],
];
