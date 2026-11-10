import 'package:flutter/material.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/app_widgets.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

// Шапка для экранов до входа: ссылка «Зарегистрируйтесь или войдите» + переключатель темы
class PublicTopBar extends StatelessWidget {
  const PublicTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: InkWell(
            onTap: () => navToSignIn(context),
            borderRadius: BorderRadius.circular(4),
            splashColor: green.withOpacity(0.2),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Text('Зарегистрируйтесь или войдите', style: TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
        const SizedBox(width: 24),
        const ThemeToggle(),
      ],
    );
  }
}
