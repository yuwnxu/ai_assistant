import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/custom_header.dart';
import '../../uiKit/custom_footer.dart';

// Экран Главная
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int? _selectedAI;
  bool _isChatsExpanded = true;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomHeader(selectedIndex: _selectedIndex, onTabSelected: _onTabSelected),
                SizedBox(height: 20),
                Container(width: 856, height: 1, color: Color(0xffE2E8F0)),
                SizedBox(height: 40),
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
      padding: EdgeInsets.only(left: 150),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChatList(),
          SizedBox(width: 20),
          Expanded(child: _selectedAI == null ? _buildWelcomeContent() : _buildChatContent(_selectedAI!)),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isChatsExpanded = !_isChatsExpanded),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/square-play.svg', width: 20, height: 20),
                SizedBox(width: 8),
                Text(
                  'Ваши чаты',
                  style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 50),
                AnimatedRotation(turns: _isChatsExpanded ? 0 : 0.5, duration: Duration(milliseconds: 200), child: SvgPicture.asset('assets/icons/chevron-up.svg', width: 10, height: 7)),
              ],
            ),
          ),
          SizedBox(height: 10),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            crossFadeState: _isChatsExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Column(children: List.generate(aiNames.length, (index) => _buildAIChatTile(aiNames[index], index: index))),
            secondChild: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Добрый день, ${userName.isNotEmpty ? userName : 'Гость'}',
          style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        Text(
          'Оцените свое состояние сегодня:',
          style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SvgPicture.asset('assets/icons/annoyed.svg', width: 20, height: 20),
            SizedBox(width: 12),
            SvgPicture.asset('assets/icons/angry.svg', width: 20, height: 20),
            SizedBox(width: 12),
            SvgPicture.asset('assets/icons/smile.svg', width: 20, height: 20),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Хотите продолжить вашу последнюю сессию?',
          style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: () => setState(() => _selectedAI = 0),
          child: Text(
            'Чат 2',
            style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline, decorationColor: link),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Или создайте новую',
          style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12),
        CustomButton(text: 'Создать', color: primaryText, width: 65, height: 24, borderRadius: 6, fontSize: 12, onPressed: () => setState(() => _selectedAI = 1)),
      ],
    );
  }

  Widget _buildChatMessage(String text, {required bool isUser, double? width, double? height}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isUser ? ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 24, height: 24, fit: BoxFit.cover)) : SvgPicture.asset('assets/icons/ai_avatar.svg', width: 24, height: 24),
        SizedBox(width: 8),
        Container(
          width: width,
          height: height,
          constraints: BoxConstraints(maxWidth: 400),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: isUser ? background : Color(0xffF1F5F9).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
          child: Text(
            text,
            style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildChatContent(int aiIndex) {
    List<Map<String, dynamic>> currentChat = chatHistories[aiIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 645,
          height: 400,
          decoration: BoxDecoration(
            color: white,
            border: Border.all(color: Color(0xffE2E8F0), width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Expanded(
                child: currentChat.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/square-play.svg', width: 48, height: 48),
                            SizedBox(height: 16),
                            Text(
                              'У вас ещё нет сообщений',
                              style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Начните диалог с ${aiNames[aiIndex]}',
                              style: TextStyle(color: hintText, fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.all(16),
                        children: currentChat
                            .map(
                              (message) => Column(
                                children: [
                                  _buildChatMessage(message['text'], isUser: message['isUser'], width: message['width']),
                                  SizedBox(height: 12),
                                ],
                              ),
                            )
                            .toList(),
                      ),
              ),
              _buildMessageInput(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffE2E8F0), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: white,
                border: Border.all(color: Color(0xffCAD5E2), width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Введите сообщение...',
                    hintStyle: TextStyle(color: hintText, fontSize: 12, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    isDense: true,
                  ),
                  style: TextStyle(color: primaryText, fontSize: 12),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(6)),
              child: Center(child: SvgPicture.asset('assets/icons/arrow-up.svg', width: 16, height: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIChatTile(String name, {required int index}) {
    bool isSelected = (_selectedAI == index);
    return GestureDetector(
      onTap: () => setState(() => _selectedAI = index),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(width: 2, height: 32, color: isSelected ? primaryText : Color(0xffE2E8F0)),
            SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(color: isSelected ? primaryText : grey, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingsContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 350,
          height: 284,
          decoration: BoxDecoration(
            color: white,
            border: Border.all(color: Color(0xffE2E8F0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 16,
                  decoration: BoxDecoration(color: Color(0xffF8FAFC), borderRadius: BorderRadius.circular(6)),
                  child: Center(
                    child: Text(
                      '2 мин',
                      style: TextStyle(fontSize: 8, fontWeight: .w600, color: message),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Тренажер “Дыхание”',
                  style: TextStyle(color: primaryText, fontSize: 16, fontWeight: .w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Интерактивная практика для мгновенного снятия напряжения. Синхронизируйте дыхание с визуальным ритмом, чтобы успокоить нервную систему и вернуть контроль над эмоциями всего за пару минут.',
                  style: TextStyle(color: grey, fontSize: 15, fontWeight: .w500),
                ),
                SizedBox(height: 24),
                CustomButton(text: 'Начать', fontSize: 12, color: primaryText, width: 60, height: 24, borderRadius: 6, onPressed: () {}),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 350,
          height: 220,
          decoration: BoxDecoration(
            color: white,
            border: Border.all(color: Color(0xffE2E8F0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 16,
                  decoration: BoxDecoration(color: Color(0xffF8FAFC), borderRadius: BorderRadius.circular(6)),
                  child: Center(
                    child: Text(
                      '2 мин',
                      style: TextStyle(fontSize: 8, fontWeight: .w600, color: message),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Тренажер “Копилка благодарностей”',
                  style: TextStyle(color: primaryText, fontSize: 16, fontWeight: .w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Формирует привычку замечать хорошее, что критически важно при депрессивных состояниях.',
                  style: TextStyle(color: grey, fontSize: 15, fontWeight: .w500),
                ),
                SizedBox(height: 24),
                CustomButton(text: 'Начать', fontSize: 12, color: primaryText, width: 60, height: 24, borderRadius: 6, onPressed: () {}),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 350,
          height: 284,
          decoration: BoxDecoration(
            color: white,
            border: Border.all(color: Color(0xffE2E8F0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 16,
                  decoration: BoxDecoration(color: Color(0xffF8FAFC), borderRadius: BorderRadius.circular(6)),
                  child: Center(
                    child: Text(
                      '2 мин',
                      style: TextStyle(fontSize: 8, fontWeight: .w600, color: message),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Тренажер “Дневник чувств”',
                  style: TextStyle(color: primaryText, fontSize: 16, fontWeight: .w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Сложно справиться с эмоцией, если она не названа. Используйте этот тренажер, чтобы точно определить свое текущее состояние, понять его причину и снизить интенсивность переживаний через осознанность.',
                  style: TextStyle(color: grey, fontSize: 15, fontWeight: .w500),
                ),
                SizedBox(height: 24),
                CustomButton(text: 'Начать', fontSize: 12, color: primaryText, width: 60, height: 24, borderRadius: 6, onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
