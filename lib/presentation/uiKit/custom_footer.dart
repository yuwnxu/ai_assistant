import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  Widget _link(String text) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500)),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SvgPicture.asset('assets/icons/arrow-up-right.svg', width: 12, height: 12, colorFilter: ColorFilter.mode(hintText, BlendMode.srcIn)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap переносит элементы на новую строку, если они не помещаются (телефон)
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 40),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 30,
        runSpacing: 8,
        children: [
          Text('Copyright © 2026', style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w400)),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(padding: const EdgeInsets.only(right: 4), child: SvgPicture.asset('assets/icons/call.svg', width: 15, height: 15)),
                ),
                const TextSpan(text: '8 (800) 2000 122 - Единый телефон доверия (бесплатно по РФ)'),
              ],
            ),
          ),
          _link('Правовая информация'),
          _link('Пользовательское соглашение'),
        ],
      ),
    );
  }
}
