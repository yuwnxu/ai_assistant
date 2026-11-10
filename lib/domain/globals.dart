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
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignIn()));
  clearControllers();
  clearErrors();
}

void navToReg(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Register()));
  clearControllers();
  clearErrors();
}

void navToHome(BuildContext context, {int tab = 0}) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(initialTab: tab)));
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

// Профиль пользователя (приходит с сервера)
String userTone = 'Поддерживающий';

// Нейросети, доступные в чатах (загружаются с сервера)
List<AiModel> aiModels = [];
