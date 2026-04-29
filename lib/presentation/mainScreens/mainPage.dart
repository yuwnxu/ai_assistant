import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';

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
          constraints: const BoxConstraints(maxWidth: 1200),
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
                const SizedBox(height: 30),
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
                        const SizedBox(height: 10),
                        Text(
                          'Найдите поддержку и понимание в любое время суток. Наш\nAI-ассистент поможет бережно разобраться со стрессом,\nвыгоранием и тревожными мыслями, гарантируя вам\nполную анонимность и безопасность.',
                          style: TextStyle(color: grey, fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 10),
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
                    const SizedBox(width: 40),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildUserMessage('Привет, мне нужна твоя помощь', customWidth: 250),
                          const SizedBox(height: 50),
                          _buildAIMessage('Привет! Конечно, я с радостью помогу. Что именно тебя интересует? Расскажи подробнее, в чем заключается твой вопрос или задача.', customWidth: 387),
                          const SizedBox(height: 50),
                          _buildUserMessage('Я хочу проанализировать свой день', customWidth: 250),
                          const SizedBox(height: 50),
                          _buildAIMessage(
                            'Привет! С удовольствием помогу тебе в этом. Психологический анализ дня помогает заметить скрытые триггеры, понять, куда уходит энергия, и осознать свои истинные потребности.\nЧтобы наш анализ был глубоким, расскажи о своем дне.',
                            customWidth: 387,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
                CustomFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserMessage(String text, {double? customWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 28, height: 28, fit: BoxFit.cover)),
            const SizedBox(width: 8),
            Container(
              width: customWidth,
              constraints: BoxConstraints(maxWidth: 387),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Color(0xffF1F5F9).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
              child: Text(
                text,
                style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        Padding(padding: const EdgeInsets.only(left: 36), child: SvgPicture.asset('assets/icons/copy.svg', width: 16, height: 16)),
      ],
    );
  }

  Widget _buildAIMessage(String text, {double? customWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/icons/ai_avatar.svg', width: 32, height: 32),
            const SizedBox(width: 8),
            Container(
              width: customWidth,
              constraints: BoxConstraints(maxWidth: 387),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Color(0xffF1F5F9).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
              child: Text(
                text,
                style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        Padding(padding: const EdgeInsets.only(left: 38), child: SvgPicture.asset('assets/icons/copy.svg', width: 16, height: 16)),
      ],
    );
  }
}
