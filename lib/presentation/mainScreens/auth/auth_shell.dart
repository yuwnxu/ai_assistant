import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';
import 'package:ai_assistant/presentation/uiKit/top_bar.dart';

// Каркас страницы авторизации: верхняя панель, карточка по центру и футер
class AuthShell extends StatelessWidget {
  final Widget card;
  final Widget? bottom; // например, индикатор шагов
  const AuthShell({super.key, required this.card, this.bottom});

  @override
  Widget build(BuildContext context) {
    final compact = isCompact(context);
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: pageHPadding(context), vertical: compact ? 20 : 40),
                    child: Column(
                      children: [
                        const PublicTopBar(),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 384),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: white, border: Border.all(color: const Color(0xffE2E8F0)), borderRadius: BorderRadius.circular(8)),
                            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25), child: card),
                          ),
                        ),
                        if (bottom != null) ...[const SizedBox(height: 30), bottom!],
                        const CustomFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
            decoration: BoxDecoration(color: background, border: Border.all(color: const Color(0xffCAD5E2)), borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20),
                const SizedBox(width: 6),
                Text('Google', style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(child: Container(height: 1, color: const Color(0xffE2E8F0))),
            const SizedBox(width: 12),
            Text('Или', style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w400)),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 1, color: const Color(0xffE2E8F0))),
          ],
        ),
      ],
    );
  }
}
