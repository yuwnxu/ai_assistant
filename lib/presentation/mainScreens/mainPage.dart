import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/chat_messages.dart';

// Экран Начальный
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = isCompact(context);

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: compact ? 0 : 90),
        Text(
          'ВАШ\nПЕРСОНАЛЬНЫЙ\nAI ПСИХОЛОГ',
          style: TextStyle(color: title, fontSize: compact ? 34 : 48, fontWeight: FontWeight.w400, height: 1),
        ),
        const SizedBox(height: 10),
        Text(
          'Найдите поддержку и понимание в любое время суток. Наш AI-ассистент поможет бережно разобраться со стрессом, выгоранием и тревожными мыслями, гарантируя вам полную анонимность и безопасность.',
          style: TextStyle(color: grey, fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 10),
        CustomButton(text: 'Начать', color: primaryText, width: 82, height: 40, borderRadius: 8, fontSize: 16, onPressed: () => navToSignIn(context)),
      ],
    );

    final demo = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildUserMessage('Привет, мне нужна твоя помощь', customWidth: 250),
          const SizedBox(height: 50),
          buildAIMessage('Привет! Конечно, я с радостью помогу. Что именно тебя интересует? Расскажи подробнее, в чем заключается твой вопрос или задача.', customWidth: 387),
          buildUserMessage('Я хочу проанализировать свой день', customWidth: 250),
          const SizedBox(height: 50),
          buildAIMessage(
            'Привет! С удовольствием помогу тебе в этом. Психологический анализ дня помогает заметить скрытые триггеры, понять, куда уходит энергия, и осознать свои истинные потребности.\n\nЧтобы наш анализ был глубоким, расскажи о своем дне.',
            customWidth: 387,
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: pageHPadding(context), vertical: compact ? 20 : 40),
                    child: Column(
                      children: [
                        const PublicTopBar(),
                        SizedBox(height: compact ? 24 : 30),
                        if (compact)
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [intro, const SizedBox(height: 24), demo])
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: intro),
                              const SizedBox(width: 40),
                              Flexible(child: demo),
                            ],
                          ),
                        const CustomFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
