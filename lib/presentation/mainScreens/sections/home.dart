import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/custom_header.dart';
import '../../uiKit/custom_footer.dart';
import 'dart:async';

enum TrainingState { list, breathing } // Состояния тренажеров

// Экран Главная
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Переменные состояния
  int _selectedIndex = 0;
  int? _selectedAI;
  bool _isChatsExpanded = true;
  TrainingState _trainingState = TrainingState.list;

  // Обработка нажатия на пункты меню
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Переменные для дыхательного тренажёра
  Timer? _breathingTimer;
  int _breathingPhase = 0;
  int _secondsRemaining = 120;
  bool _isTrainingActive = false;
  bool _isTrainingComplete = false;

  // Запуск цикла вдох/выдох
  void _startBreathingCycle() {
    _secondsRemaining = 120;
    _breathingPhase = 0;
    _isTrainingActive = true;
    _isTrainingComplete = false;

    _breathingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining <= 0) {
          timer.cancel();
          _isTrainingActive = false;
          _isTrainingComplete = true;
        } else {
          _secondsRemaining--;
          // Меняем фазу каждые 5 секунд
          if (_secondsRemaining % 5 == 0 && _secondsRemaining % 10 != 0) {
            _breathingPhase = 1; // выдох
          } else if (_secondsRemaining % 10 == 0) {
            _breathingPhase = 0; // вдох
          }
        }
      });
    });
  }

  // Сброс тренажёра в начальное состояние
  void _resetBreathingTraining() {
    _breathingTimer?.cancel();
    setState(() {
      _isTrainingActive = false;
      _isTrainingComplete = false;
      _secondsRemaining = 120;
      _breathingPhase = 0;
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
                // Шапка с навигацией
                CustomHeader(selectedIndex: _selectedIndex, onTabSelected: _onTabSelected),
                SizedBox(height: 20),
                Container(width: 856, height: 1, color: Color(0xffE2E8F0)),
                SizedBox(height: 40),
                // Основной контент
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

  // Переключение между экранами
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

  // Главный контент
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

  // Список AI чатов
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

  // Блок приветствия
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
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              splashColor: green.withOpacity(0.2),
              child: Padding(padding: EdgeInsets.all(4), child: SvgPicture.asset('assets/icons/annoyed.svg', width: 20, height: 20)),
            ),
            SizedBox(width: 12),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              splashColor: green.withOpacity(0.2),
              child: Padding(padding: EdgeInsets.all(4), child: SvgPicture.asset('assets/icons/angry.svg', width: 20, height: 20)),
            ),
            SizedBox(width: 12),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              splashColor: green.withOpacity(0.2),
              child: Padding(padding: EdgeInsets.all(4), child: SvgPicture.asset('assets/icons/smile.svg', width: 20, height: 20)),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Хотите продолжить вашу последнюю сессию?',
          style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        InkWell(
          onTap: () => setState(() => _selectedAI = 0),
          borderRadius: BorderRadius.circular(4),
          splashColor: link.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Чат 2',
              style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline, decorationColor: link),
            ),
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

  // Сообщение в чате
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

  // Контент чата с выбранным AI
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

  // Поле ввода сообщения и кнопка отправки
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
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            splashColor: Colors.white.withOpacity(0.3),
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

  // Пункт списка AI чатов
  Widget _buildAIChatTile(String name, {required int index}) {
    bool isSelected = (_selectedAI == index);
    return InkWell(
      onTap: () => setState(() => _selectedAI = index),
      borderRadius: BorderRadius.circular(8),
      splashColor: green.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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

  // Список всех тренажёров
  Widget _buildTrainingsList() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Тренажер “Дыхание”
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
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: message),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Тренажер “Дыхание”',
                  style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Интерактивная практика для мгновенного снятия напряжения. Синхронизируйте дыхание с визуальным ритмом, чтобы успокоить нервную систему и вернуть контроль над эмоциями всего за пару минут.',
                  style: TextStyle(color: grey, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 24),
                CustomButton(
                  text: 'Начать',
                  fontSize: 12,
                  color: primaryText,
                  width: 60,
                  height: 24,
                  borderRadius: 6,
                  onPressed: () {
                    setState(() {
                      _trainingState = TrainingState.breathing;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        // Тренажер “Копилка благодарностей”
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
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: message),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Тренажер “Копилка благодарностей”',
                  style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Формирует привычку замечать хорошее, что критически важно при депрессивных состояниях.',
                  style: TextStyle(color: grey, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 24),
                CustomButton(text: 'Начать', fontSize: 12, color: primaryText, width: 60, height: 24, borderRadius: 6, onPressed: () {}),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        // Тренажер “Дневник чувств”
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
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: message),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Тренажер “Дневник чувств”',
                  style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Сложно справиться с эмоцией, если она не названа. Используйте этот тренажер, чтобы точно определить свое текущее состояние, понять его причину и снизить интенсивность переживаний через осознанность.',
                  style: TextStyle(color: grey, fontSize: 15, fontWeight: FontWeight.w500),
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

  // Стартовый экран тренажёра "Дыхание"
  Widget _buildTrainingStart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: _startBreathingCycle,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            customBorder: const CircleBorder(),
            child: Container(
              width: 250,
              height: 264,
              decoration: BoxDecoration(shape: BoxShape.circle, color: breathLight),
              child: Center(
                child: Container(
                  width: 154,
                  height: 154,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: breathSoft),
                  child: Center(
                    child: Text(
                      'Начать',
                      style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Активный тренажёр
  Widget _buildActiveTraining() {
    double innerCircleSize = (_breathingPhase == 0) ? 219 : 190;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Анимированный круг
          AnimatedContainer(
            duration: Duration(seconds: 5),
            curve: Curves.easeInOut,
            width: 250,
            height: 264,
            decoration: BoxDecoration(shape: BoxShape.circle, color: breathPrimary),
            child: Center(
              child: AnimatedContainer(
                duration: Duration(seconds: 5),
                curve: Curves.easeInOut,
                width: innerCircleSize,
                height: innerCircleSize,
                decoration: BoxDecoration(shape: BoxShape.circle, color: breathLight),
                child: Center(
                  child: Container(
                    width: 154,
                    height: 154,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: breathSoft),
                    child: Center(
                      child: Text(
                        _breathingPhase == 0 ? 'Вдох' : 'Выдох',
                        style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Таймер обратного отсчёта
          Text(
            'Осталось: ${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
            style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              _breathingTimer?.cancel();
              setState(() {
                _isTrainingActive = false;
                _isTrainingComplete = false;
                _trainingState = TrainingState.list;
                _secondsRemaining = 120;
                _breathingPhase = 0;
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              width: 100,
              height: 36,
              decoration: BoxDecoration(
                color: white,
                border: Border.all(color: grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Завершить',
                  style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Экран завершения тренажёра
  Widget _buildTrainingComplete() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 264,
            decoration: BoxDecoration(shape: BoxShape.circle, color: breathLight),
            child: Center(
              child: Container(
                width: 154,
                height: 154,
                decoration: BoxDecoration(shape: BoxShape.circle, color: breathSoft),
                child: Center(
                  child: Text(
                    'Отлично!',
                    style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          CustomButton(text: 'Еще раз', color: green, width: 97, height: 28, borderRadius: 8, fontSize: 14, onPressed: _resetBreathingTraining),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              _resetBreathingTraining();
              setState(() {
                _trainingState = TrainingState.list;
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              'Завершить',
              style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Главный переключатель контента тренажёров
  Widget _buildTrainingsContent() {
    if (_isTrainingComplete) {
      return _buildTrainingComplete();
    }

    // Если тренажёр активен
    if (_isTrainingActive) {
      return _buildActiveTraining();
    }

    // Стартовый экран тренажёра
    if (_trainingState == TrainingState.breathing) {
      return _buildTrainingStart();
    }

    // Список тренажёров
    return _buildTrainingsList();
  }
}
