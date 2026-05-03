import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';

import '../../uiKit/custom_footer.dart';

// Экран Главная
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int? _selectedAI = null;
  bool _isChatsExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Text(
                        'Главная',
                        style: TextStyle(color: _selectedIndex == 0 ? green : grey, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Text(
                        'Тренажеры',
                        style: TextStyle(color: _selectedIndex == 1 ? green : grey, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Text(
                      'Правовая информация',
                      style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 150),
                    SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
                    const SizedBox(width: 16),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 20, height: 20, fit: BoxFit.cover)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(width: 856, height: 1, color: const Color(0xffE2E8F0)),
                const SizedBox(height: 40),
                Expanded(child: _buildContent()),
                SizedBox(height: 180),
                CustomFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildTrainingsContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 150),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Левая часть - список чатов
          SizedBox(
            width: 250,  // фиксированная ширина
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isChatsExpanded = !_isChatsExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/square-play.svg', width: 20, height: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Ваши чаты',
                        style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 50),
                      AnimatedRotation(
                        turns: _isChatsExpanded ? 0 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: SvgPicture.asset('assets/icons/chevron-up.svg', width: 10, height: 7),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: _isChatsExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstChild: Column(
                    children: [
                      _buildAIChatTile('ChatGPT 5.1', index: 0),
                      _buildAIChatTile('Gemini 3.1 Pro', index: 1),
                      _buildAIChatTile('Claude Sonnet 4.6', index: 2),
                      _buildAIChatTile('DeepSeek V3', index: 3),
                      _buildAIChatTile('Grok 4', index: 4),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),  // ← отступ 20px
          // Правая часть - контент
          Expanded(
            child: _selectedAI == null
                ? _buildWelcomeContent()
                : _buildChatContent(_selectedAI!),
          ),
        ],
      ),
    );
  }

  // Контент приветствия (когда AI не выбран)
  Widget _buildWelcomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Добрый день, ${userName.isNotEmpty ? userName : 'Гость'}',
          style: TextStyle(
            color: primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Оцените свое состояние сегодня:',
          style: TextStyle(
            color: primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SvgPicture.asset('assets/icons/annoyed.svg', width: 20, height: 20),
            const SizedBox(width: 12),
            SvgPicture.asset('assets/icons/angry.svg', width: 20, height: 20),
            const SizedBox(width: 12),
            SvgPicture.asset('assets/icons/smile.svg', width: 20, height: 20),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Хотите продолжить вашу последнюю сессию?',
          style: TextStyle(
            color: primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Чат 2',
            style: TextStyle(
              color: link,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: link,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Или создайте новую',
          style: TextStyle(
            color: primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Создать',
          color: primaryText,
          width: 65,
          height: 24,
          borderRadius: 6,
          fontSize: 12,
          onPressed: () {},
        ),
      ],
    );
  }

  // Контент чата (когда AI выбран)
  Widget _buildChatContent(int aiIndex) {
    List<String> aiNames = [
      'ChatGPT 5.1',
      'Gemini 3.1 Pro',
      'Claude Sonnet 4.6',
      'DeepSeek V3',
      'Grok 4',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Чат с ${aiNames[aiIndex]}',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: Text(
              'История переписки с ${aiNames[aiIndex]}',
              style: TextStyle(color: grey, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIChatTile(String name, {required int index}) {
    bool isSelected = (_selectedAI == index);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAI = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 2,
              height: 32,
              color: isSelected ? primaryText : const Color(0xffE2E8F0),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? primaryText : grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingsContent() {
    return Center(
      child: Text('Контент Тренажеров', style: TextStyle(color: primaryText, fontSize: 24)),
    );
  }
}