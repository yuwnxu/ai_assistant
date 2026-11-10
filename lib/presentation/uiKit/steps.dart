import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

// Индикатор шагов регистрации (Регистрация → Настройки → Готово); step: 0, 1 или 2
class OnboardingSteps extends StatelessWidget {
  final int step;
  const OnboardingSteps({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final compact = isCompact(context);
    final titleSize = compact ? 13.0 : 18.0;
    final textSize = compact ? 11.0 : 18.0;

    Widget label(String title, String text) => Expanded(
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: TextStyle(color: message, fontSize: titleSize, fontWeight: FontWeight.w500)),
          Text(text, textAlign: TextAlign.center, style: TextStyle(color: grey, fontSize: textSize, fontWeight: FontWeight.w400)),
        ],
      ),
    );

    Widget line(bool active) => Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(height: 2, color: active ? green : grey),
      ),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/icons/id_card.svg', width: 56, height: 56),
              line(true),
              SvgPicture.asset(step == 0 ? 'assets/icons/settings.svg' : 'assets/icons/circle_settings.svg', width: step == 0 ? 21 : 56, height: step == 0 ? 23 : 56),
              line(step >= 2),
              SvgPicture.asset('assets/icons/check.svg', width: 19, height: 13),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label('Регистрация', 'Зарегистрируйтесь в сервисе'),
              const SizedBox(width: 8),
              label('Настройки', 'Настройте предпочтения и конфиденциальность'),
              const SizedBox(width: 8),
              label('Готово', 'Приятного пользования!'),
            ],
          ),
        ],
      ),
    );
  }
}
