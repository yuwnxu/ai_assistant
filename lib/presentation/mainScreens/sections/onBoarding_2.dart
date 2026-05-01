import 'package:flutter/material.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/chat_messages.dart';

//Экран Онбординг ч.2
class OnBoarding2 extends StatefulWidget {
  const OnBoarding2({super.key});

  @override
  State<OnBoarding2> createState() => _OnBoarding2State();
}

class _OnBoarding2State extends State<OnBoarding2> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () {
                        navToSignIn(context);
                      },
                      child: Text(
                        'Зарегистрируйтесь или войдите',
                        style: TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0),
                      ),
                    ),
                    const SizedBox(width: 100),
                    SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Container(width: 608, height: 1, color: const Color(0xffE2E8F0)),
                const SizedBox(height: 30),
                Text(
                  'Как к вам обращаться?',
                  style: TextStyle(color: title, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 384,
                  height: 180,
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: const Color(0xffE2E8F0), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Имя',
                          style: TextStyle(
                            color: message,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Введите имя, по которому к Вам будет обращаться цифровой психолог',
                          style: TextStyle(
                            color: grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 336,
                          height: 24,
                          decoration: BoxDecoration(
                            color: white,
                            border: Border.all(color: const Color(0xffCAD5E2), width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextField(
                            controller: _nameController,
                            cursorColor: green,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Имя',
                              hintStyle: TextStyle(
                                color: hintText,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(left: 8,
                              top: 4),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 335,
                          height: 1,
                          color: const Color(0xffE2E8F0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/id_card.svg', width: 56, height: 56),
                    SizedBox(width: 16),
                    Container(width: 184, height: 2, color: grey),
                    SizedBox(width: 16),
                    SvgPicture.asset('assets/icons/settings.svg', width: 21, height: 23),
                    SizedBox(width: 16),
                    Container(width: 184, height: 2, color: grey),
                    SizedBox(width: 16),
                    SvgPicture.asset('assets/icons/check.svg', width: 19, height: 13),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Регистрация',
                          style: TextStyle(color: message, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Зарегистрируйтесь в сервисе',
                          style: TextStyle(color: grey, fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Настройки',
                          style: TextStyle(color: message, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Настройте предпочтения и\n    конфиденциальность',
                          style: TextStyle(color: grey, fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Готово',
                          style: TextStyle(color: message, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Приятного пользования!',
                          style: TextStyle(color: grey, fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 180),
                CustomFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}