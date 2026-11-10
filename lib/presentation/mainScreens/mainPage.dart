import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/presentation/uiKit/app_scaffold.dart';
import 'package:ai_assistant/presentation/uiKit/app_widgets.dart';
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
        SizedBox(height: compact ? 0 : 60),
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
        CustomButton(text: 'Начать', color: buttonDark, width: 82, height: 40, borderRadius: 8, fontSize: 16, onPressed: () => navToSignIn(context)),
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

    return AppScaffold(
      header: const PublicTopBar(),
      child: Padding(
        padding: EdgeInsets.only(bottom: compact ? 8 : 0),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [FadeIn(child: intro), const SizedBox(height: 24), FadeIn(delay: const Duration(milliseconds: 250), child: demo)],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: FadeIn(child: intro)),
                  const SizedBox(width: 40),
                  Flexible(child: FadeIn(delay: const Duration(milliseconds: 250), child: demo)),
                ],
              ),
      ),
    );
  }
}
