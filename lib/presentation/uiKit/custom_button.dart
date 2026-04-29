import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.color, required this.width, required this.height, required this.borderRadius, required this.onPressed, this.fontSize = 14,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
        child: Text(
          text,
          style: TextStyle(color: white, fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
