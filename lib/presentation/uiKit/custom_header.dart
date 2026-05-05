import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/settings.dart';

class CustomHeader extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomHeader({super.key, required this.selectedIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onTabSelected(0),
          child: Text(
            'Главная',
            style: TextStyle(color: selectedIndex == 0 ? green : grey, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 25),
        GestureDetector(
          onTap: () => onTabSelected(1),
          child: Text(
            'Тренажеры',
            style: TextStyle(color: selectedIndex == 1 ? green : grey, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 25),
        Text(
          'Правовая информация',
          style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 150),
        SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 20, height: 20, fit: BoxFit.cover)),
          ),
        ),
      ],
    );
  }
}
