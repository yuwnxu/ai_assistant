import 'package:flutter/material.dart';
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

  const CustomTextField({
    super.key,
    required this.type,
    required this.controller,
    required this.borderRadius,
    required this.colorCursor,
    required this.title,
    required this.hintText,
    this.errorText,
    this.width = 336,
    this.height = 44,
  });

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
          style: TextStyle(
            color: message,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Поле ввода
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: white,
            border: Border.all(
              color: hasError ? error : Color(0xffCAD5E2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: TextField(
            cursorColor: widget.colorCursor,
            controller: widget.controller,
            obscureText: widget.type == TextFieldType.password,
            style: TextStyle(
              color: primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Color(0xff90A1B9),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        // Ошибка
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: error,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}