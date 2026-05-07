import 'package:ai_assistant/presentation/mainScreens/sections/home.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/onBoarding.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/mainScreens/auth/signIn.dart';
import 'package:ai_assistant/presentation/mainScreens/auth/register.dart';
import 'package:ai_assistant/presentation/mainScreens/mainPage.dart';

// Основные переменные и функции приложения

// Навигация
void navToSignIn(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
  clearControllers();
  clearErrors();
}

void navToReg(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Register()));
  clearControllers();
  clearErrors();
}

void navToHome(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  clearControllers();
  clearErrors();
}

void navToMain(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
  clearControllers();
  clearErrors();
}

void navToBoard1(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OnBoarding1()));
  clearControllers();
  clearErrors();
}

void navToBoard2(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OnBoarding2()));
  clearControllers();
  clearErrors();
}

void navToBoard3(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OnBoarding3()));
  clearControllers();
  clearErrors();
}

// Очистка контроллеров
void clearControllers() {
  emailController.clear();
  passwordController.clear();
  nameController.clear();
}

// Очистка ошибок
void clearErrors() {
  emailError = null;
  passwordError = null;
}

// Контроллеры
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController = TextEditingController();

// Текст ошибки
String? emailError;
String? passwordError;

// Имя пользователя
String userName = '';

// Список AI
List<String> aiNames = ['ChatGPT 5.1', 'Gemini 3.1 Pro', 'Claude Sonnet 4.6', 'DeepSeek V3', 'Grok 4'];

// Диалоги
List<List<Map<String, dynamic>>> chatHistories = [
  // ChatGPT 5.1
  [
    {'text': 'Привет', 'isUser': true, 'width': 65},
    {'text': 'Привет! Рад тебя слышать! Как прошел твой день?', 'isUser': false, 'width': 325},
    {'text': 'Я очень устала на работе', 'isUser': true, 'width': 170},
    {
      'text':
          'Понимаю это состояние — когда хочется просто\n«выключиться». Вот несколько способов\nрасслабиться максимально эффективно:\n  • Сними рабочую одежду сразу. Это психологический сигнал мозгу: «день окончен».\n  • Теплый душ или ванна. Вода отлично снимает статическое напряжение и «смывает» дневные заботы.\n  • Правило 15 минут тишины. Ляг на кровать или диван, выключи свет и отложи телефон.\nПросто полежи в полной тишине. Это даст нервной системе передышку от информационного шума.\nМой совет прямо сейчас:\nПоставь телефон на зарядку в другой комнате, выпей стакан воды и просто полежи 10 минут\nс закрытыми глазами.',
      'isUser': false,
      'width': 575,
    },
  ],
  // Gemini 3.1 Pro
  [],
  // Claude Sonnet 4.6
  [
    {'text': 'Не могу уснуть уже несколько ночей', 'isUser': true, 'width': 240},
    {'text': 'Бессонница — серьёзная проблема. Попробуй перед сном выпить тёплый чай и отложить телефон за час до сна.', 'isUser': false, 'width': 450},
    {'text': 'Я пробовала, не помогает', 'isUser': true, 'width': 200},
    {'text': 'Тогда рекомендую технику дыхания 4-7-8.\nВдох на 4 секунды, задержка на 7, выдох на 8. Повтори 5 раз.', 'isUser': false, 'width': 470},
  ],
  // DeepSeek V3
  [
    {'text': 'Чувствую тревогу без причины', 'isUser': true, 'width': 210},
    {'text': 'Тревожность часто связана с накопившимся напряжением. Давай сделаем простое упражнение: назови 5 предметов, которые ты видишь вокруг.', 'isUser': false, 'width': 500},
    {'text': '1. Ноутбук, 2. Кружка, 3. Окно, 4. Книга, 5. Ручка', 'isUser': true, 'width': 380},
    {'text': 'Отлично! Теперь ты вернулся в реальность. Как ощущения?', 'isUser': false, 'width': 350},
  ],
  // Grok 4
  [
    {'text': 'Я выгорела, ничего не хочется делать', 'isUser': true, 'width': 250},
    {'text': 'Выгорание — это не лень, а состояние истощения. Тебе нужен отдых. Попробуй взять перерыв на 15 минут.', 'isUser': false, 'width': 450},
    {'text': 'У меня нет времени на отдых', 'isUser': true, 'width': 210},
    {'text': 'Даже 5 минут глубокого дыхания помогут. Начни с малого. Дыши со мной: вдох... выдох...', 'isUser': false, 'width': 400},
  ],
];
