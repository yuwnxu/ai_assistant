import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/data/api.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/custom_header.dart';
import '../../uiKit/custom_footer.dart';
import 'dart:async';

enum TrainingState { list, breathing } // Состояния тренажеров

// Экран Главная
class Home extends StatefulWidget {
  final int initialTab; // 0 — чаты, 1 — тренажёры
  const Home({super.key, this.initialTab = 0});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Переменные состояния
  late int _selectedIndex = widget.initialTab;
  int? _selectedAI;
  int _lastAI = 0; // последний открытый чат
  bool _isChatsExpanded = true;
  TrainingState _trainingState = TrainingState.list;

  // Чаты с нейросетями
  final Map<String, List<ChatMessage>> _chats = {};
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _modelsLoading = true;
  String? _modelsError;
  bool _isSending = false;
  String? _chatError;

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  @override
  void dispose() {
    _breathingTimer?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // Загружаем список нейросетей с сервера
  Future<void> _loadModels() async {
    setState(() {
      _modelsLoading = true;
      _modelsError = null;
    });
    try {
      final models = await Api.models();
      if (mounted) setState(() => aiModels = models);
    } on ApiException catch (e) {
      if (mounted) setState(() => _modelsError = e.message);
    } finally {
      if (mounted) setState(() => _modelsLoading = false);
    }
  }

  // Открываем чат и подгружаем историю переписки
  Future<void> _openChat(int index) async {
    final key = aiModels[index].key;
    setState(() {
      _selectedAI = index;
      _lastAI = index;
      _chatError = null;
    });
    if (_chats.containsKey(key)) {
      _scrollToEnd();
      return;
    }
    try {
      final history = await Api.chat(key);
      if (mounted) setState(() => _chats[key] = history);
      _scrollToEnd();
    } on ApiException catch (e) {
      if (mounted) setState(() => _chatError = e.message);
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  // Отправка сообщения нейросети
  Future<void> _sendMessage() async {
    final text = _input.text.trim();
    if (text.isEmpty || _isSending || _selectedAI == null) return;
    final key = aiModels[_selectedAI!].key;
    final messages = _chats.putIfAbsent(key, () => []);

    setState(() {
      messages.add(ChatMessage(text, true));
      _input.clear();
      _isSending = true;
      _chatError = null;
    });
    _scrollToEnd();

    try {
      final reply = await Api.send(key, text);
      if (mounted) setState(() => messages.add(reply));
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          messages.removeLast(); // сообщение не дошло — возвращаем текст в поле
          _input.text = text;
          _chatError = e.message;
        });
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
      _scrollToEnd();
    }
  }

  // Очистка истории текущего чата
  Future<void> _clearChat() async {
    if (_selectedAI == null) return;
    final key = aiModels[_selectedAI!].key;
    try {
      await Api.clearChat(key);
      if (mounted) setState(() => _chats[key] = []);
    } on ApiException catch (e) {
      if (mounted) setState(() => _chatError = e.message);
    }
  }

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

    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining <= 0) {
          timer.cancel();
          _isTrainingActive = false;
          _isTrainingComplete = true;
        } else {
          _secondsRemaining--;
          // Меняем фазу каждые 6 секунд
          if (_secondsRemaining % 6 == 0 && _secondsRemaining % 12 != 0) {
            _breathingPhase = 1; // выдох
          } else if (_secondsRemaining % 12 == 0) {
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
    final compact = isCompact(context);
    final chatOpen = _selectedIndex == 0 && _selectedAI != null;
    final vPad = compact ? 16.0 : 40.0;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: EdgeInsets.fromLTRB(pageHPadding(context), vPad, pageHPadding(context), compact ? 8 : vPad),
              child: Column(
                children: [
                  // Шапка с навигацией
                  CustomHeader(selectedIndex: _selectedIndex, onTabSelected: _onTabSelected),
                  SizedBox(height: compact ? 12 : 20),
                  Container(constraints: const BoxConstraints(maxWidth: 856), height: 1, color: const Color(0xffE2E8F0)),
                  SizedBox(height: compact ? 16 : 40),
                  // Основной контент: открытый чат занимает всю высоту, остальное прокручивается
                  Expanded(
                    child: chatOpen
                        ? Column(children: [Expanded(child: _buildContent()), if (!compact) const CustomFooter()])
                        : SingleChildScrollView(
                            child: Column(children: [_buildContent(), const CustomFooter()]),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Переключение между экранами
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 1:
        return _buildTrainingsContent();
      default:
        return _buildHomeContent();
    }
  }

  // Главный контент
  Widget _buildHomeContent() {
    final compact = isCompact(context);
    final welcome = _selectedAI == null;

    if (compact) {
      // Телефон: список чатов — горизонтальные «чипы» над окном переписки
      if (welcome) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildWelcomeContent(), const SizedBox(height: 24), _buildChatList()]);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChatChips(),
          const SizedBox(height: 12),
          Expanded(child: _buildChatContent(_selectedAI!)),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width >= 1100 ? 150 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChatList(),
          const SizedBox(width: 20),
          Expanded(
            child: welcome
                ? _buildWelcomeContent()
                : Align(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 645), child: _buildChatContent(_selectedAI!)),
                  ),
          ),
        ],
      ),
    );
  }

  // Горизонтальный список чатов (телефон)
  Widget _buildChatChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(aiModels.length, (i) {
          final selected = _selectedAI == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(aiModels[i].title, style: TextStyle(color: selected ? white : message, fontSize: 13, fontWeight: FontWeight.w500)),
              selected: selected,
              showCheckmark: false,
              selectedColor: primaryText,
              backgroundColor: white,
              side: const BorderSide(color: Color(0xffE2E8F0)),
              onSelected: (_) => _openChat(i),
            ),
          );
        }),
      ),
    );
  }

  // Список AI чатов
  Widget _buildChatList() {
    final compact = isCompact(context);
    Widget list;
    if (_modelsLoading) {
      list = Padding(padding: const EdgeInsets.all(8), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: green)));
    } else if (_modelsError != null) {
      list = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_modelsError!, style: TextStyle(color: error, fontSize: 13)),
          TextButton(onPressed: _loadModels, child: Text('Повторить', style: TextStyle(color: link))),
        ],
      );
    } else {
      list = Column(children: List.generate(aiModels.length, (index) => _buildAIChatTile(aiModels[index].title, index: index)));
    }

    return SizedBox(
      width: compact ? double.infinity : 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isChatsExpanded = !_isChatsExpanded),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/square-play.svg', width: 20, height: 20),
                const SizedBox(width: 8),
                Text('Ваши чаты', style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(width: 50),
                AnimatedRotation(turns: _isChatsExpanded ? 0 : 0.5, duration: const Duration(milliseconds: 200), child: SvgPicture.asset('assets/icons/chevron-up.svg', width: 10, height: 7)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isChatsExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: SizedBox(width: double.infinity, child: list),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // Блок приветствия
  Widget _buildWelcomeContent() {
    final ready = aiModels.isNotEmpty;
    final lastTitle = ready ? aiModels[_lastAI.clamp(0, aiModels.length - 1)].title : '';
    final txt = TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w500);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Добрый день, ${userName.isNotEmpty ? userName : 'Гость'}', style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Text('Оцените свое состояние сегодня:', style: txt),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final icon in ['annoyed', 'angry', 'smile']) ...[
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                splashColor: green.withOpacity(0.2),
                child: Padding(padding: const EdgeInsets.all(6), child: SvgPicture.asset('assets/icons/$icon.svg', width: 22, height: 22)),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 10),
        if (ready) ...[
          Text('Хотите продолжить вашу последнюю сессию?', style: txt),
          InkWell(
            onTap: () => _openChat(_lastAI.clamp(0, aiModels.length - 1)),
            borderRadius: BorderRadius.circular(4),
            splashColor: link.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(lastTitle, style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline, decorationColor: link)),
            ),
          ),
          const SizedBox(height: 6),
          Text('Или выберите нейросеть в списке чатов', style: txt),
          const SizedBox(height: 12),
          CustomButton(text: 'Открыть чат', color: primaryText, width: 120, height: 32, borderRadius: 6, fontSize: 12, onPressed: () => _openChat(_lastAI.clamp(0, aiModels.length - 1))),
        ],
      ],
    );
  }

  // Сообщение в чате
  Widget _buildChatMessage(String text, {required bool isUser}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isUser ? ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 24, height: 24, fit: BoxFit.cover)) : SvgPicture.asset('assets/icons/ai_avatar.svg', width: 24, height: 24),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: isUser ? background : const Color(0xffF1F5F9).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
            child: SelectableText(text, style: TextStyle(color: message, fontSize: 13, fontWeight: FontWeight.w400, height: 1.4)),
          ),
        ),
      ],
    );
  }

  // Контент чата с выбранным AI
  Widget _buildChatContent(int aiIndex) {
    final compact = isCompact(context);
    final key = aiModels[aiIndex].key;
    final currentChat = _chats[key];

    Widget body;
    if (currentChat == null && _chatError == null) {
      body = Center(child: CircularProgressIndicator(color: green));
    } else if (currentChat == null || (currentChat.isEmpty && !_isSending)) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icons/square-play.svg', width: 48, height: 48),
              const SizedBox(height: 16),
              Text('У вас ещё нет сообщений', style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text('Начните диалог с ${aiModels[aiIndex].title}', textAlign: TextAlign.center, style: TextStyle(color: hintText, fontSize: 12, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      );
    } else {
      body = ListView(
        controller: _scroll,
        padding: const EdgeInsets.all(16),
        children: [
          for (final m in currentChat) ...[_buildChatMessage(m.text, isUser: m.isUser), const SizedBox(height: 12)],
          if (_isSending) ...[_buildChatMessage('Печатает...', isUser: false), const SizedBox(height: 12)],
        ],
      );
    }

    final box = Container(
      height: compact ? null : 500,
      decoration: BoxDecoration(color: white, border: Border.all(color: const Color(0xffE2E8F0)), borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE2E8F0)))),
            child: Row(
              children: [
                Expanded(child: Text(aiModels[aiIndex].title, style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w600))),
                TextButton(
                  onPressed: (currentChat == null || currentChat.isEmpty) ? null : _clearChat,
                  child: Text('Очистить', style: TextStyle(color: grey, fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(child: body),
          if (_chatError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Align(alignment: Alignment.centerLeft, child: Text(_chatError!, style: TextStyle(color: error, fontSize: 12, fontWeight: FontWeight.w500))),
            ),
          _buildMessageInput(),
        ],
      ),
    );
    return box;
  }

  // Поле ввода сообщения и кнопка отправки
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xffE2E8F0)))),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: white, border: Border.all(color: const Color(0xffCAD5E2)), borderRadius: BorderRadius.circular(6)),
              child: TextField(
                controller: _input,
                minLines: 1,
                maxLines: 4,
                maxLength: 2000,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                cursorColor: green,
                decoration: InputDecoration(
                  hintText: 'Введите сообщение...',
                  hintStyle: TextStyle(color: hintText, fontSize: 13, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
                style: TextStyle(color: primaryText, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _isSending ? null : _sendMessage,
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.white.withOpacity(0.3),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: _isSending ? hintText : green, borderRadius: BorderRadius.circular(8)),
              child: Center(child: SvgPicture.asset('assets/icons/arrow-up.svg', width: 18, height: 18)),
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
      onTap: () => _openChat(index),
      borderRadius: BorderRadius.circular(8),
      splashColor: green.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(width: 2, height: 32, color: isSelected ? primaryText : const Color(0xffE2E8F0)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(name, style: TextStyle(color: isSelected ? primaryText : grey, fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  // Карточка тренажёра
  Widget _trainingCard(String name, String description, {required String width, VoidCallback? onStart}) {
    return Container(
      width: width == 'full' ? double.infinity : 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: white, border: Border.all(color: const Color(0xffE2E8F0)), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xffF8FAFC), borderRadius: BorderRadius.circular(6)),
            child: Text('2 мин', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: message)),
          ),
          const SizedBox(height: 8),
          Text(name, style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: grey, fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          CustomButton(text: 'Начать', fontSize: 12, color: primaryText, width: 60, height: 28, borderRadius: 6, onPressed: onStart ?? () {}),
        ],
      ),
    );
  }

  // Список всех тренажёров (на телефоне карточки идут одна под другой)
  Widget _buildTrainingsList() {
    final w = isCompact(context) ? 'full' : 'fixed';
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _trainingCard(
          'Тренажер “Дыхание”',
          'Интерактивная практика для мгновенного снятия напряжения. Синхронизируйте дыхание с визуальным ритмом, чтобы успокоить нервную систему и вернуть контроль над эмоциями всего за пару минут.',
          width: w,
          onStart: () => setState(() => _trainingState = TrainingState.breathing),
        ),
        _trainingCard('Тренажер “Копилка благодарностей”', 'Формирует привычку замечать хорошее, что критически важно при депрессивных состояниях.', width: w),
        _trainingCard(
          'Тренажер “Дневник чувств”',
          'Сложно справиться с эмоцией, если она не названа. Используйте этот тренажер, чтобы точно определить свое текущее состояние, понять его причину и снизить интенсивность переживаний через осознанность.',
          width: w,
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
