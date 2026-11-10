import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

// Сообщение (используется на заставках): аватар + пузырь, который сжимается под ширину экрана
Widget _bubbleRow(Widget avatar, String text, double? customWidth) {
  return Builder(
    builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avatar,
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  width: isCompact(context) ? null : customWidth,
                  constraints: const BoxConstraints(maxWidth: 387),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xffF1F5F9).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
                  child: Text(text, style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: SvgPicture.asset('assets/icons/copy.svg', width: 16, height: 16, colorFilter: ColorFilter.mode(grey, BlendMode.srcIn)),
          ),
        ],
      );
    },
  );
}

// Сообщение пользователя
Widget buildUserMessage(String text, {double? customWidth}) {
  return _bubbleRow(ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 28, height: 28, fit: BoxFit.cover)), text, customWidth);
}

// Сообщение AI
Widget buildAIMessage(String text, {double? customWidth}) {
  return _bubbleRow(SvgPicture.asset('assets/icons/ai_avatar.svg', width: 30, height: 30), text, customWidth);
}
