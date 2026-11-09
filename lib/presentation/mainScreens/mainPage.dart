import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/chat_messages.dart';

// Экран Начальный
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
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
                    InkWell(
                      onTap: () {
                        navToSignIn(context);
                      },
                      borderRadius: BorderRadius.circular(4),
                      splashColor: green.withOpacity(0.2),
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text(
                          'Зарегистрируйтесь или войдите',
                          style: TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0),
                        ),
                      ),
                    ),
                    SizedBox(width: 100),
                    SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
                  ],
                ),
                SizedBox(height: 20),
                Container(width: 608, height: 1, color: Color(0xffE2E8F0)),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 90),
                        Text(
                          'ВАШ\nПЕРСОНАЛЬНЫЙ\nAI ПСИХОЛОГ',
                          style: TextStyle(color: title, fontSize: 48, fontWeight: FontWeight.w400, height: 1),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Найдите поддержку и понимание в любое время суток. Наш\nAI-ассистент поможет бережно разобраться со стрессом,\nвыгоранием и тревожными мыслями, гарантируя вам\nполную анонимность и безопасность.',
                          style: TextStyle(color: grey, fontSize: 14, height: 1.5),
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          text: 'Начать',
                          color: primaryText,
                          width: 82,
                          height: 40,
                          borderRadius: 8,
                          fontSize: 16,
                          onPressed: () {
                            navToSignIn(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildUserMessage('Привет, мне нужна твоя помощь', customWidth: 250),
                          SizedBox(height: 50),
                          buildAIMessage('Привет! Конечно, я с радостью помогу. Что именно тебя интересует? Расскажи подробнее, в чем заключается твой вопрос или задача.', customWidth: 387),
                          buildUserMessage('Я хочу проанализировать свой день', customWidth: 250),
                          SizedBox(height: 50),
                          buildAIMessage(
                            'Привет! С удовольствием помогу тебе в этом. Психологический анализ дня помогает заметить скрытые триггеры, понять, куда уходит энергия, и осознать свои истинные потребности.\n\nЧтобы наш анализ был глубоким, расскажи о своем дне.',
                            customWidth: 387,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                CustomFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
