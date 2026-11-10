import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

// Иконка из assets, перекрашенная под текущую тему
Widget themedSvg(String asset, {double? width, double? height}) {
  return SvgPicture.asset(asset, width: width, height: height, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn));
}

const String _moonSvg = '<svg viewBox="0 0 24 24" fill="none" stroke="#000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>';

// Кнопка смены темы: солнце ↔ луна с анимацией
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggleTheme,
      borderRadius: BorderRadius.circular(20),
      splashColor: green.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) => RotationTransition(
            turns: Tween<double>(begin: 0.25, end: 0).animate(animation),
            child: FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child)),
          ),
          child: isDarkMode
              ? SvgPicture.string(_moonSvg, key: const ValueKey('moon'), width: 20, height: 20, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn))
              : SvgPicture.asset('assets/icons/sun.svg', key: const ValueKey('sun'), width: 20, height: 20, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
        ),
      ),
    );
  }
}

// Плавное появление с небольшим сдвигом снизу. delay — задержка для «каскада» элементов
class FadeIn extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;
  const FadeIn({super.key, required this.child, this.delay = Duration.zero, this.duration = const Duration(milliseconds: 500), this.offset = 16});

  @override
  Widget build(BuildContext context) {
    final total = duration + delay;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(delay.inMilliseconds / total.inMilliseconds, 1, curve: Curves.easeOutCubic),
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, (1 - v) * offset), child: child),
      ),
      child: child,
    );
  }
}

// Эффект нажатия и наведения: элемент слегка увеличивается/уменьшается
class PressableScale extends StatefulWidget {
  final Widget child;
  const PressableScale({super.key, required this.child});

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Listener(
        onPointerDown: (_) => setState(() => _down = true),
        onPointerUp: (_) => setState(() => _down = false),
        onPointerCancel: (_) => setState(() => _down = false),
        child: AnimatedScale(scale: _down ? 0.96 : (_hover ? 1.03 : 1), duration: const Duration(milliseconds: 150), curve: Curves.easeOut, child: widget.child),
      ),
    );
  }
}

// Переключатель с анимацией
class AppSwitch extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  const AppSwitch({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: 30,
        height: 18,
        padding: const EdgeInsets.all(2),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(color: value ? green : borderLight, borderRadius: BorderRadius.circular(9), border: Border.all(color: value ? green : border)),
        child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: white, shape: BoxShape.circle)),
      ),
    );
  }
}

// Поле ввода с идеально выровненным по центру текстом
class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final double height;
  final double fontSize;
  final bool obscure;
  final int maxLength;
  final int maxLines;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  const InputBox({
    super.key,
    required this.controller,
    required this.hint,
    this.height = 40,
    this.fontSize = 14,
    this.obscure = false,
    this.maxLength = 200,
    this.maxLines = 1,
    this.errorText,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final multi = maxLines > 1;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: BoxConstraints(minHeight: height),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: surface, border: Border.all(color: errorText != null ? error : borderInput), borderRadius: BorderRadius.circular(6)),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscure,
        maxLength: maxLength,
        minLines: 1,
        maxLines: maxLines,
        cursorColor: green,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        textAlignVertical: TextAlignVertical.center,
        // фиксируем высоту строки, чтобы текст стоял строго по центру
        strutStyle: StrutStyle(fontSize: fontSize, height: 1.25, forceStrutHeight: true, leading: 0),
        style: TextStyle(color: primaryText, fontSize: fontSize, height: 1.25),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintText, fontSize: fontSize, height: 1.25),
          border: InputBorder.none,
          counterText: '',
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: multi ? 10 : (height - fontSize * 1.25) / 2),
        ),
      ),
    );
  }
}
