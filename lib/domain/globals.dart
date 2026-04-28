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
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
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