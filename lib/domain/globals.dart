import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/mainScreens/auth/signIn.dart';
import 'package:ai_assistant/presentation/mainScreens/auth/register.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/home.dart';
import 'package:ai_assistant/presentation/mainScreens/mainPage.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/onBoarding.dart';
import 'package:ai_assistant/data/api.dart';

//Основные переменные и функции приложения

//Навигация

void navToSignIn(BuildContext context) {
  Navigator.of(context).pushReplacement(fadeSlideRoute(const SignIn()));
  clearControllers();
  clearErrors();
}

void navToReg(BuildContext context) {
  Navigator.of(context).pushReplacement(fadeSlideRoute(const Register()));
  clearControllers();
  clearErrors();
}

void navToHome(BuildContext context, {int tab = 0}) {
  Navigator.of(context).pushReplacement(fadeSlideRoute(Home(initialTab: tab)));
  clearControllers();
  clearErrors();
}

void navToMain(BuildContext context) {
  Navigator.of(context).pushReplacement(fadeSlideRoute(const MainPage()));
  clearControllers();
  clearErrors();
}

void navToBoard1(BuildContext context) {
  Navigator.of(context).pushReplacement(fadeSlideRoute(const OnBoarding1()));
  clearControllers();
  clearErrors();
}

void navToBoard2(BuildContext context) {
  Navigator.of(context).pushReplacement(fadeSlideRoute(const OnBoarding2()));
  clearControllers();
  clearErrors();
}

void navToBoard3(BuildContext context) {
  Navigator.of(context).pushReplacement(fadeSlideRoute(const OnBoarding3()));
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

// Профиль пользователя (приходит с сервера)
String userTone = 'Поддерживающий';

// Нейросети, доступные в чатах (загружаются с сервера)
List<AiModel> aiModels = [];

// Переход между экранами: плавное появление с лёгким сдвигом
Route<T> fadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondary) => page,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(curved), child: child),
      );
    },
  );
}
