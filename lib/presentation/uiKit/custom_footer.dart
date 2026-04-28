import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Copyright © 2025',
            style: TextStyle(
              color: grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 30),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/call.svg',
                width: 15,
                height: 15,
              ),
              const SizedBox(width: 4),
              Text(
                '124 - Единый телефон доверия (бесплатно по РФ)',
                style: TextStyle(
                  color: grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(width: 30),
          InkWell(
            onTap: () {
              // TODO: переход на экран правовой информации
            },
            child: Row(
              children: [
                Text(
                  'Правовая информация',
                  style: TextStyle(
                    color: grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SvgPicture.asset(
                    'assets/icons/arrow-up-right.svg',
                    width: 12,
                    height: 12,
                    colorFilter: ColorFilter.mode(hintText, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          InkWell(
            onTap: () {
              // TODO: переход на экран пользовательского соглашения
            },
            child: Row(
              children: [
                Text(
                  'Пользовательское соглашение',
                  style: TextStyle(
                    color: grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SvgPicture.asset(
                    'assets/icons/arrow-up-right.svg',
                    width: 12,
                    height: 12,
                    colorFilter: ColorFilter.mode(hintText, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}