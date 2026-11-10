import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/app_widgets.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';

// Ссылка-текст «Завершить» под тренажёрами
Widget _textLink(String text, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500)),
    ),
  );
}

const String _heartSvg = '<svg viewBox="0 0 24 24"><path fill="#00C16A" d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>';

// ============================ Копилка благодарностей ============================
// Пользователь называет три вещи, за которые благодарен. Каждая «падает» в банку в виде сердечка,
// банка наполняется светом.
class GratitudeTrainer extends StatefulWidget {
  final VoidCallback onExit;
  const GratitudeTrainer({super.key, required this.onExit});

  @override
  State<GratitudeTrainer> createState() => _GratitudeTrainerState();
}

class _GratitudeTrainerState extends State<GratitudeTrainer> with SingleTickerProviderStateMixin {
  static const int _goal = 3;
  final List<String> _items = [];
  final TextEditingController _input = TextEditingController();
  final FocusNode _focus = FocusNode();
  late final AnimationController _glow = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

  @override
  void dispose() {
    _glow.dispose();
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _add() {
    final text = _input.text.trim();
    if (text.isEmpty || _items.length >= _goal) return;
    setState(() {
      _items.add(text);
      _input.clear();
    });
    _focus.requestFocus(); // не теряем фокус после Enter
  }

  // Позиции, где «лежат» сердечки в банке (x от центра, y от верха области банки)
  static const List<Offset> _rest = [Offset(-34, 168), Offset(34, 168), Offset(0, 128)];

  @override
  Widget build(BuildContext context) {
    final done = _items.length >= _goal;
    final level = _items.length / _goal;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              done ? 'Отлично! Копилка полна' : 'Назовите ${_goal - _items.length} ${_goal - _items.length == 1 ? 'вещь' : 'вещи'}, за которые вы благодарны сегодня',
              textAlign: TextAlign.center,
              style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            // Банка
            SizedBox(
              width: 200,
              height: 240,
              child: AnimatedBuilder(
                animation: _glow,
                builder: (context, _) => Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // свечение
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 160 + 20 * _glow.value * level,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(30), bottom: Radius.circular(40)),
                          boxShadow: [BoxShadow(color: green.withOpacity(0.35 * level * (0.6 + 0.4 * _glow.value)), blurRadius: 40, spreadRadius: 4)],
                        ),
                      ),
                    ),
                    // стекло банки и уровень «света»
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 150,
                        height: 200,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: surface,
                          border: Border.all(color: grey, width: 2),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24), bottom: Radius.circular(40)),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(duration: const Duration(milliseconds: 900), curve: Curves.easeOutCubic, height: 150 * level, color: breathLight),
                      ),
                    ),
                    // крышка
                    Positioned(top: 22, child: Container(width: 100, height: 14, decoration: BoxDecoration(color: grey, borderRadius: BorderRadius.circular(7)))),
                    // падающие сердечки
                    for (int i = 0; i < _items.length; i++) _FallingHeart(key: ValueKey(i), rest: _rest[i]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Уже названное
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  for (int i = 0; i < _items.length; i++)
                    FadeIn(
                      key: ValueKey('item$i'),
                      delay: const Duration(milliseconds: 600),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('${i + 1}. ${_items[i]}', textAlign: TextAlign.center, style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (!done) ...[
              Row(
                children: [
                  Expanded(
                    child: InputBox(controller: _input, focusNode: _focus, hint: 'Например: вкусный кофе', height: 40, maxLength: 80, textInputAction: TextInputAction.done, onSubmitted: (_) => _add()),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(text: 'Добавить', color: green, width: 96, height: 40, borderRadius: 6, fontSize: 13, onPressed: _add),
                ],
              ),
            ] else ...[
              CustomButton(text: 'Ещё раз', color: green, width: 120, height: 36, borderRadius: 8, fontSize: 14, onPressed: () => setState(_items.clear)),
            ],
            const SizedBox(height: 12),
            _textLink('Завершить', widget.onExit),
          ],
        ),
      ),
    );
  }
}

// Сердечко, которое падает в банку и подпрыгивает
class _FallingHeart extends StatelessWidget {
  final Offset rest;
  const _FallingHeart({super.key, required this.rest});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.bounceOut,
      builder: (context, t, child) => Positioned(
        top: -30 + (rest.dy + 30) * t,
        left: 100 + rest.dx - 17,
        child: Opacity(opacity: math.min(1, t * 4), child: child),
      ),
      child: SvgPicture.string(_heartSvg, width: 34, height: 34),
    );
  }
}

// ============================ Дневник чувств ============================
// 1) выбрать чувство → 2) оценить силу (круг растёт) → 3) назвать причину → 4) «выдох»: круг уменьшается.
class FeelingsTrainer extends StatefulWidget {
  final VoidCallback onExit;
  const FeelingsTrainer({super.key, required this.onExit});

  @override
  State<FeelingsTrainer> createState() => _FeelingsTrainerState();
}

class _Feeling {
  final String name;
  final Color color;
  const _Feeling(this.name, this.color);
}

class _FeelingsTrainerState extends State<FeelingsTrainer> with SingleTickerProviderStateMixin {
  static const List<_Feeling> _feelings = [
    _Feeling('Радость', Color(0xffEFB100)),
    _Feeling('Спокойствие', Color(0xff00C16A)),
    _Feeling('Грусть', Color(0xff2B7FFF)),
    _Feeling('Тревога', Color(0xff9B5DE5)),
    _Feeling('Злость', Color(0xffFB2C36)),
    _Feeling('Усталость', Color(0xff62748E)),
  ];
  static const List<String> _causes = ['Работа или учёба', 'Отношения', 'Здоровье', 'Недосып', 'Другое'];

  int _stage = 0; // 0 — выбор, 1 — сила, 2 — причина, 3 — выдох
  int _selected = 0;
  double _intensity = 6;
  String? _cause;
  bool _released = false;
  late final AnimationController _float = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  Color get _color => _feelings[_selected].color;

  void _restart() => setState(() {
    _stage = 0;
    _intensity = 6;
    _cause = null;
    _released = false;
  });

  Widget _circle(double size, {String? label}) {
    return AnimatedBuilder(
      animation: _float,
      builder: (context, _) {
        final pulse = 1 + 0.04 * math.sin(_float.value * 2 * math.pi);
        return SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: Transform.scale(
              scale: pulse,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(duration: const Duration(milliseconds: 400), width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: _color.withOpacity(0.18))),
                  AnimatedContainer(duration: const Duration(milliseconds: 400), width: size * 0.7, height: size * 0.7, decoration: BoxDecoration(shape: BoxShape.circle, color: _color.withOpacity(0.45))),
                  AnimatedContainer(duration: const Duration(milliseconds: 400), width: size * 0.4, height: size * 0.4, decoration: BoxDecoration(shape: BoxShape.circle, color: _color)),
                  if (label != null) Text(label, style: const TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _sizeFor(double intensity) => 60 + intensity * 14; // 74…200

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_stage) {
      case 0:
        content = Column(
          key: const ValueKey(0),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Что вы чувствуете сейчас?', style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _float,
              builder: (context, _) => Wrap(
                alignment: WrapAlignment.center,
                spacing: 18,
                runSpacing: 18,
                children: [
                  for (int i = 0; i < _feelings.length; i++)
                    Transform.translate(
                      offset: Offset(0, 6 * math.sin(_float.value * 2 * math.pi + i * 1.1)),
                      child: PressableScale(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _selected = i;
                            _stage = 1;
                          }),
                          child: Column(
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: _feelings[i].color.withOpacity(0.2), border: Border.all(color: _feelings[i].color, width: 2)),
                                child: Center(child: Container(width: 26, height: 26, decoration: BoxDecoration(shape: BoxShape.circle, color: _feelings[i].color))),
                              ),
                              const SizedBox(height: 6),
                              Text(_feelings[i].name, style: TextStyle(color: message, fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      case 1:
        content = Column(
          key: const ValueKey(1),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Насколько сильно: ${_feelings[_selected].name.toLowerCase()}?', style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _circle(_sizeFor(_intensity), label: _intensity.round().toString()),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Slider(value: _intensity, min: 1, max: 10, divisions: 9, activeColor: _color, inactiveColor: borderLight, onChanged: (v) => setState(() => _intensity = v)),
            ),
            const SizedBox(height: 8),
            CustomButton(text: 'Далее', color: green, width: 110, height: 36, borderRadius: 8, fontSize: 14, onPressed: () => setState(() => _stage = 2)),
          ],
        );
      case 2:
        content = Column(
          key: const ValueKey(2),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Что могло повлиять на это чувство?', textAlign: TextAlign.center, style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in _causes)
                  GestureDetector(
                    onTap: () => setState(() => _cause = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(color: _cause == c ? _color : surface, border: Border.all(color: _cause == c ? _color : borderInput), borderRadius: BorderRadius.circular(20)),
                      child: Text(c, style: TextStyle(color: _cause == c ? white : message, fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Назвать чувство',
              color: green,
              width: 170,
              height: 36,
              borderRadius: 8,
              fontSize: 14,
              onPressed: () => setState(() {
                _cause ??= 'Другое';
                _stage = 3;
              }),
            ),
          ],
        );
      default:
        final end = _sizeFor(math.max(1, (_intensity * 0.5).roundToDouble()));
        content = Column(
          key: const ValueKey(3),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_released ? 'Стало легче' : 'Сделайте медленный выдох…', style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: _sizeFor(_intensity), end: end),
              duration: const Duration(seconds: 6),
              curve: Curves.easeInOut,
              onEnd: () => setState(() => _released = true),
              builder: (context, size, _) => SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: _color.withOpacity(0.18))),
                      Container(width: size * 0.7, height: size * 0.7, decoration: BoxDecoration(shape: BoxShape.circle, color: _color.withOpacity(0.45))),
                      Container(width: size * 0.4, height: size * 0.4, decoration: BoxDecoration(shape: BoxShape.circle, color: _color)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                'Я чувствую «${_feelings[_selected].name.toLowerCase()}» — ${_cause!.toLowerCase()}. Назвав чувство, вы уже снизили его силу: ${_intensity.round()} → ${math.max(1, (_intensity * 0.5).round())}.',
                textAlign: TextAlign.center,
                style: TextStyle(color: grey, fontSize: 14, height: 1.4),
              ),
            ),
            if (_released) ...[
              const SizedBox(height: 16),
              FadeIn(child: CustomButton(text: 'Ещё раз', color: green, width: 120, height: 36, borderRadius: 8, fontSize: 14, onPressed: _restart)),
            ],
          ],
        );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation), child: child),
              ),
              child: content,
            ),
            const SizedBox(height: 16),
            _textLink('Завершить', widget.onExit),
          ],
        ),
      ),
    );
  }
}
