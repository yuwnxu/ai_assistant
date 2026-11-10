import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Цвета приложения. Это обычные переменные, поэтому при смене темы их значения просто переприсваиваются.
const Color white = Color(0xffFFFFFF); // чисто белый (текст на тёмных и зелёных кнопках)

bool isDarkMode = false;

Color background = Color(0xffF8FAFC); // фон страницы
Color surface = Color(0xffFFFFFF); // карточки и поля ввода
Color surfaceSoft = Color(0xffF8FAFC); // лёгкая подложка
Color bubbleColor = Color(0xffF1F5F9); // пузырь сообщения
Color borderLight = Color(0xffE2E8F0); // тонкие линии и рамки
Color borderInput = Color(0xffCAD5E2); // рамки полей ввода
Color title = Color(0xff000000);
Color grey = Color(0xff62748E);
Color message = Color(0xff314158);
Color green = Color(0xff00C16A);
Color primaryText = Color(0xff0F172B);
Color hintText = Color(0xff90A1B9);
Color border = Color(0xff90A1B9);
Color link = Color(0xff2B7FFF);
Color error = Color(0xffFB2C36);
Color iconColor = Color(0xff0F172B); // монохромные иконки
Color buttonDark = Color(0xff0F172B); // тёмные кнопки
Color buttonDarkSoft = Color(0xE50F172B);
Color breathLight = Color(0xffB3F5D1);
Color breathSoft = Color(0xffD9FBE8);
Color breathPrimary = Color(0xff75EDAE);

// Переключает палитру
void applyTheme(bool dark) {
  isDarkMode = dark;
  background = dark ? Color(0xff0B1220) : Color(0xffF8FAFC);
  surface = dark ? Color(0xff121B2E) : Color(0xffFFFFFF);
  surfaceSoft = dark ? Color(0xff0F1729) : Color(0xffF8FAFC);
  bubbleColor = dark ? Color(0xff22304D) : Color(0xffF1F5F9);
  borderLight = dark ? Color(0xff223049) : Color(0xffE2E8F0);
  borderInput = dark ? Color(0xff33415C) : Color(0xffCAD5E2);
  title = dark ? Color(0xffFFFFFF) : Color(0xff000000);
  grey = dark ? Color(0xff94A3B8) : Color(0xff62748E);
  message = dark ? Color(0xffCBD5E1) : Color(0xff314158);
  primaryText = dark ? Color(0xffE2E8F0) : Color(0xff0F172B);
  hintText = dark ? Color(0xff64748B) : Color(0xff90A1B9);
  border = dark ? Color(0xff64748B) : Color(0xff90A1B9);
  link = dark ? Color(0xff60A5FA) : Color(0xff2B7FFF);
  error = dark ? Color(0xffF87171) : Color(0xffFB2C36);
  iconColor = dark ? Color(0xffE2E8F0) : Color(0xff0F172B);
  buttonDark = dark ? Color(0xff2C3E63) : Color(0xff0F172B);
  buttonDarkSoft = dark ? Color(0xff1E2B47) : Color(0xE50F172B);
  breathLight = dark ? Color(0xff14573A) : Color(0xffB3F5D1);
  breathSoft = dark ? Color(0xff0F3D2A) : Color(0xffD9FBE8);
  breathPrimary = dark ? Color(0xff1F7A52) : Color(0xff75EDAE);
}

// Перерисовывает все экраны (цвета читаются из переменных, а не из Theme)
void _rebuildAll() {
  void visit(Element element) {
    element.markNeedsBuild();
    element.visitChildren(visit);
  }

  WidgetsBinding.instance.rootElement?.visitChildren(visit);
}

// Загружает сохранённую тему (по умолчанию — как в системе)
Future<void> loadTheme() async {
  bool dark = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  try {
    final prefs = await SharedPreferences.getInstance();
    dark = prefs.getBool('dark') ?? dark;
  } catch (_) {}
  applyTheme(dark);
}

// Переключает светлую/тёмную тему и запоминает выбор
Future<void> toggleTheme() async {
  applyTheme(!isDarkMode);
  _rebuildAll();
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark', isDarkMode);
  } catch (_) {}
}
