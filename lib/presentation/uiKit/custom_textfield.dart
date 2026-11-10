import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/app_widgets.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

// Тип текстового поля
enum TextFieldType { text, password }

// Текстовое поле
class CustomTextField extends StatefulWidget {
  final TextFieldType type; // Тип поля
  final TextEditingController controller; // Контроллер
  final double borderRadius; // Закругление поля
  final Color colorCursor; // Цвет курсора
  final String? errorText; // Текст ошибки
  final String title; // Заголовок
  final String hintText; // Текст-подсказка
  final double width; // Ширина поля
  final double height; // Высота поля

  const CustomTextField({super.key, required this.type, required this.controller, required this.borderRadius, required this.colorCursor, required this.title, required this.hintText, this.errorText, this.width = double.infinity, this.height = 44});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    bool hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок
        Text(
          widget.title,
          style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        // Поле ввода
        SizedBox(
          width: widget.width,
          child: InputBox(controller: widget.controller, hint: widget.hintText, height: widget.height, obscure: widget.type == TextFieldType.password, errorText: widget.errorText),
        ),
        // Ошибка
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: error, fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
      ],
    );
  }
}
