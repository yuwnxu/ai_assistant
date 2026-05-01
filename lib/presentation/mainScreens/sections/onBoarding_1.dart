import 'package:flutter/material.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/chat_messages.dart';

//Экран Онбординг ч.1
class OnBoarding1 extends StatefulWidget {
  const OnBoarding1({super.key});

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 25),
                      GestureDetector(
                        onTap: () {
                          navToSignIn(context);
                        },
                        child: Text(
                          'Зарегистрируйтесь или войдите',
                          style: TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0),
                        ),
                      ),
                      SizedBox(width: 100),
                      SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(width: 608, height: 1, color: Color(0xffE2E8F0)),
                  SizedBox(height: 30),
                  Text(
                    'Какой тон общения вы предпочитаете?',
                    style: TextStyle(color: title, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildUserMessage('Я сегодня совсем выгорел на работе, чувствую себя\nабсолютно опустошенным.?', customWidth: 344),
                            SizedBox(height: 30),
                            buildAIMessage('Давай проанализируем это состояние. Когда именно ты\nначал замечать упадок  сил? Есть ли конкретные типы\nзадач или триггеры, которые предшествуют этому\nощущению чаще всего?', customWidth: 387),
                            SizedBox(height: 30),
                            buildUserMessage('Кажется, бесконечные задачи, которым\nнет конца. Я просто хочу, чтобы меня\nоставили в покое.', customWidth: 275),
                            SizedBox(height: 30),
                            buildAIMessage("Понял. Ситуация выглядит как потеря контроля над\nграфиком и приоритетами. Давай попробуем\nклассифицировать твои задачи по методу Эйзенхауэра,\nчтобы понять, какие процессы объективно приводят к\nдефициту ресурса.", customWidth: 387),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildUserMessage('Я сегодня совсем выгорел на работе, чувствую себя\nабсолютно опустошенным.?', customWidth: 344),
                            SizedBox(height: 30),
                            buildAIMessage('Мне очень жаль, что твой день был таким тяжелым. Ты\nимеешь полное право чувствовать усталость, это\nдействительно изматывающее состояние. Что сейчас\nзабирает у тебя больше всего душевных сил?', customWidth: 387),
                            SizedBox(height: 30),
                            buildUserMessage('Кажется, бесконечные задачи, которым\nнет конца. Я просто хочу, чтобы меня\nоставили в покое.', customWidth: 280),
                            SizedBox(height: 30),
                            buildAIMessage("Понимаю тебя. Это ощущение «перегруза» — важный\nсигнал твоего тела. Давай сегодня не будем ничего\nрешать, а просто попробуем найти способ вернуть тебе\nхотя бы немного спокойствия.", customWidth: 387),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'Аналитический',
                        color: primaryText,
                        width: 272,
                        height: 40,
                        borderRadius: 8,
                        fontSize: 16,
                        onPressed: () {
                          navToBoard2(context);
                        },
                      ),
                      SizedBox(width: 160),
                      CustomButton(
                        text: 'Поддерживающий',
                        color: primaryText,
                        width: 272,
                        height: 40,
                        borderRadius: 8,
                        fontSize: 16,
                        onPressed: () {
                          navToBoard2(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Четкий разбор ситуации,\nпоиск логических связей и\nрациональных решений',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: grey, fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(width: 200),
                      Text(
                        'Мягкое общение, фокус на\nсопереживании и поиске\nэмоциональной опоры',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: grey, fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ],
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
                  SizedBox(height: 30),
                  CustomFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
