import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/settings.dart';

class CustomHeader extends StatelessWidget {
  final int selectedIndex; // -1, если ни одна вкладка не выбрана (например, в настройках)
  final Function(int) onTabSelected;

  const CustomHeader({super.key, required this.selectedIndex, required this.onTabSelected});

  Widget _tab(String text, int index) {
    return InkWell(
      onTap: () => onTabSelected(index),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Text(text, style: TextStyle(color: selectedIndex == index ? green : grey, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _icons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
        const SizedBox(width: 16),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings())),
          borderRadius: BorderRadius.circular(20),
          splashColor: green.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 24, height: 24, fit: BoxFit.cover)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isCompact(context)) {
      // Мобильная версия: вкладки слева, иконки справа
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Wrap(spacing: 12, children: [_tab('Главная', 0), _tab('Тренажеры', 1)]),
          ),
          _icons(context),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tab('Главная', 0),
        const SizedBox(width: 25),
        _tab('Тренажеры', 1),
        const SizedBox(width: 25),
        Text('Правовая информация', style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(width: 150),
        _icons(context),
      ],
    );
  }
}
