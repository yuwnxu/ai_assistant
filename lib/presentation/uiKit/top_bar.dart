import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

// Верхняя панель для экранов до входа: ссылка «Зарегистрируйтесь или войдите» + разделитель
class PublicTopBar extends StatelessWidget {
  const PublicTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 32,
          runSpacing: 8,
          children: [
            InkWell(
              onTap: () => navToSignIn(context),
              borderRadius: BorderRadius.circular(4),
              splashColor: green.withOpacity(0.2),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text('Зарегистрируйтесь или войдите', style: TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ),
            SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
          ],
        ),
        const SizedBox(height: 20),
        Container(constraints: const BoxConstraints(maxWidth: 608), height: 1, color: const Color(0xffE2E8F0)),
      ],
    );
  }
}
