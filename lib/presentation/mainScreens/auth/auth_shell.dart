import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/presentation/uiKit/app_scaffold.dart';
import 'package:ai_assistant/presentation/uiKit/app_widgets.dart';
import 'package:ai_assistant/presentation/uiKit/top_bar.dart';

// Каркас страницы авторизации: шапка, карточка по центру и (при необходимости) индикатор шагов
class AuthShell extends StatelessWidget {
  final Widget card;
  final Widget? bottom; // например, индикатор шагов
  const AuthShell({super.key, required this.card, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const PublicTopBar(),
      child: Column(
        children: [
          FadeIn(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 384),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: surface, border: Border.all(color: borderLight), borderRadius: BorderRadius.circular(8)),
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25), child: card),
              ),
            ),
          ),
          if (bottom != null) ...[const SizedBox(height: 30), FadeIn(delay: const Duration(milliseconds: 200), child: bottom!)],
        ],
      ),
    );
  }
}

// Кнопка «Google» и разделитель «Или»
class GoogleOrDivider extends StatelessWidget {
  const GoogleOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(5),
          splashColor: green.withOpacity(0.2),
          child: Container(
            width: double.infinity,
            height: 32,
            decoration: BoxDecoration(color: background, border: Border.all(color: borderInput), borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                themedSvg('assets/icons/google.svg', width: 20, height: 20),
                const SizedBox(width: 6),
                Text('Google', style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(child: Container(height: 1, color: borderLight)),
            const SizedBox(width: 12),
            Text('Или', style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w400)),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 1, color: borderLight)),
          ],
        ),
      ],
    );
  }
}
