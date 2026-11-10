import 'package:flutter/material.dart';

// Ширина, начиная с которой показываем «десктопную» раскладку
const double compactBreakpoint = 900;

// true, если экран узкий (телефон или маленькое окно)
bool isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < compactBreakpoint;

// Боковые отступы страницы
double pageHPadding(BuildContext context) => isCompact(context) ? 16 : 40;
