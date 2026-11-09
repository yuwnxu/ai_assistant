import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

// Сообщение пользователя
Widget buildUserMessage(String text, {double? customWidth}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 28, height: 28, fit: BoxFit.cover)),
          SizedBox(width: 8),
          Container(
            width: customWidth,
            constraints: BoxConstraints(maxWidth: 387),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color(0xffF1F5F9).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
            child: Text(
              text,
              style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      SizedBox(height: 4),
      Padding(
        padding: const EdgeInsets.only(left: 36),
        child: SvgPicture.asset('assets/icons/copy.svg', width: 16, height: 16, colorFilter: ColorFilter.mode(grey, BlendMode.srcIn)),
      ),
    ],
  );
}

// Сообщение AI
Widget buildAIMessage(String text, {double? customWidth}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/icons/ai_avatar.svg', width: 30, height: 30),
          SizedBox(width: 8),
          Container(
            width: customWidth,
            constraints: BoxConstraints(maxWidth: 387),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color(0xffF1F5F9).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
            child: Text(
              text,
              style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      SizedBox(height: 4),
      Padding(
        padding: const EdgeInsets.only(left: 36),
        child: SvgPicture.asset('assets/icons/copy.svg', width: 16, height: 16, colorFilter: ColorFilter.mode(grey, BlendMode.srcIn)),
      ),
    ],
  );
}
