import 'package:flutter/material.dart';
import 'package:ai_assistant/data/api.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';
import 'package:ai_assistant/presentation/uiKit/steps.dart';
import 'package:ai_assistant/presentation/uiKit/top_bar.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/chat_messages.dart';

// Общий каркас экранов онбординга: панель сверху, заголовок, содержимое, шаги и футер
class _OnboardingPage extends StatelessWidget {
  final String heading;
  final Widget child;
  final int step;
  const _OnboardingPage({required this.heading, required this.child, required this.step});

  @override
  Widget build(BuildContext context) {
    final compact = isCompact(context);
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
                        const SizedBox(height: 30),
                        Text(heading, textAlign: TextAlign.center, style: TextStyle(color: title, fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 30),
                        child,
                        const SizedBox(height: 30),
                        OnboardingSteps(step: step),
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

// Белая карточка с полем и кнопкой «Далее»
class _OnboardingCard extends StatelessWidget {
  final Widget content;
  final VoidCallback onNext;
  const _OnboardingCard({required this.content, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 384),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: white, border: Border.all(color: const Color(0xffE2E8F0)), borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            const SizedBox(height: 24),
            Container(height: 1, color: const Color(0xffE2E8F0)),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: const BorderSide(color: Color(0xffCAD5E2))),
                  ),
                  child: Text('Далее', style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Экран Онбординг ч.1 — выбор тона общения
class OnBoarding1 extends StatelessWidget {
  const OnBoarding1({super.key});

  Future<void> _choose(BuildContext context, String tone) async {
    userTone = tone;
    try {
      await Api.updateProfile(tone: tone);
    } catch (_) {
      // не страшно: тон можно изменить позже в настройках
    }
    if (context.mounted) navToBoard2(context);
  }

  @override
  Widget build(BuildContext context) {
    final compact = isCompact(context);

    final analytic = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildUserMessage('Я сегодня совсем выгорел на работе, чувствую себя абсолютно опустошенным.', customWidth: 344),
          const SizedBox(height: 30),
          buildAIMessage('Давай проанализируем это состояние. Когда именно ты начал замечать упадок сил? Есть ли конкретные типы задач или триггеры, которые предшествуют этому ощущению чаще всего?', customWidth: 387),
          const SizedBox(height: 30),
          buildUserMessage('Кажется, бесконечные задачи, которым нет конца. Я просто хочу, чтобы меня оставили в покое.', customWidth: 275),
          const SizedBox(height: 30),
          buildAIMessage('Понял. Ситуация выглядит как потеря контроля над графиком и приоритетами. Давай попробуем классифицировать твои задачи по методу Эйзенхауэра, чтобы понять, какие процессы объективно приводят к дефициту ресурса.', customWidth: 387),
        ],
      ),
    );

    final support = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildUserMessage('Я сегодня совсем выгорел на работе, чувствую себя абсолютно опустошенным.', customWidth: 344),
          const SizedBox(height: 30),
          buildAIMessage('Мне очень жаль, что твой день был таким тяжелым. Ты имеешь полное право чувствовать усталость, это действительно изматывающее состояние. Что сейчас забирает у тебя больше всего душевных сил?', customWidth: 387),
          const SizedBox(height: 30),
          buildUserMessage('Кажется, бесконечные задачи, которым нет конца. Я просто хочу, чтобы меня оставили в покое.', customWidth: 280),
          const SizedBox(height: 30),
          buildAIMessage('Понимаю тебя. Это ощущение «перегруза» — важный сигнал твоего тела. Давай сегодня не будем ничего решать, а просто попробуем найти способ вернуть тебе хотя бы немного спокойствия.', customWidth: 387),
        ],
      ),
    );

    Widget option(String name, String description) => Column(
      children: [
        CustomButton(text: name, color: primaryText, width: compact ? double.infinity : 272, height: 44, borderRadius: 8, fontSize: 16, onPressed: () => _choose(context, name)),
        const SizedBox(height: 10),
        Text(description, textAlign: TextAlign.center, style: TextStyle(color: grey, fontSize: 16, fontWeight: FontWeight.w400)),
      ],
    );

    final analyticOption = option('Аналитический', 'Четкий разбор ситуации, поиск логических связей и рациональных решений');
    final supportOption = option('Поддерживающий', 'Мягкое общение, фокус на сопереживании и поиске эмоциональной опоры');

    return _OnboardingPage(
      heading: 'Какой тон общения вы предпочитаете?',
      step: 0,
      child: compact
          ? Column(children: [analytic, const SizedBox(height: 16), analyticOption, const SizedBox(height: 32), support, const SizedBox(height: 16), supportOption])
          : Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: analytic),
                    const SizedBox(width: 16),
                    Expanded(child: support),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: analyticOption)),
                    Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: supportOption)),
                  ],
                ),
              ],
            ),
    );
  }
}

//Экран Онбординг ч.2 — имя
class OnBoarding2 extends StatefulWidget {
  const OnBoarding2({super.key});

  @override
  State<OnBoarding2> createState() => _OnBoarding2State();
}

class _OnBoarding2State extends State<OnBoarding2> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    userName = _nameController.text.trim();
    try {
      await Api.updateProfile(name: userName);
    } catch (_) {
      // имя можно задать позже в настройках
    }
    if (mounted) navToBoard3(context);
  }

  @override
  Widget build(BuildContext context) {
    return _OnboardingPage(
      heading: 'Как к вам обращаться?',
      step: 1,
      child: _OnboardingCard(
        onNext: _next,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Имя', style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w600)),
            Text('Введите имя, по которому к Вам будет обращаться цифровой психолог', style: TextStyle(color: grey, fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              height: 36,
              decoration: BoxDecoration(color: white, border: Border.all(color: const Color(0xffCAD5E2)), borderRadius: BorderRadius.circular(6)),
              child: TextField(
                controller: _nameController,
                cursorColor: green,
                maxLength: 60,
                style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: 'Имя',
                  hintStyle: TextStyle(color: hintText, fontSize: 14, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Экран Онбординг ч.3 — конфиденциальность
class OnBoarding3 extends StatefulWidget {
  const OnBoarding3({super.key});

  @override
  State<OnBoarding3> createState() => _OnBoarding3State();
}

class _OnBoarding3State extends State<OnBoarding3> {
  bool _isHistoryOn = true;

  @override
  Widget build(BuildContext context) {
    return _OnboardingPage(
      heading: 'Настройки конфиденциальности',
      step: 2,
      child: _OnboardingCard(
        onNext: () => navToHome(context),
        content: Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => _isHistoryOn = !_isHistoryOn),
              child: SvgPicture.asset(_isHistoryOn ? 'assets/icons/switch-on.svg' : 'assets/icons/switch-off.svg', width: 28, height: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Хранить историю', style: TextStyle(color: primaryText, fontSize: 12, fontWeight: FontWeight.w600)),
                  Text('Это поможет нам лучше анализировать диалоги', style: TextStyle(color: grey, fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
