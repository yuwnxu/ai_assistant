import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/app_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/data/api.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/custom_header.dart';
import '../../uiKit/custom_footer.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:ai_assistant/presentation/mainScreens/sections/trainers.dart';
import 'package:ai_assistant/presentation/uiKit/app_scaffold.dart';
import 'package:ai_assistant/presentation/uiKit/app_widgets.dart';

enum TrainingState { list, breathing, gratitude, feelings } // Состояния тренажеров

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
  String? _lastKey; // ключ чата, где пользователь писал последним (null — ещё не писал)
  int? _mood; // выбранное настроение
  bool _isChatsExpanded = true;
  TrainingState _trainingState = TrainingState.list;

  // Чаты с нейросетями
  final Map<String, List<ChatMessage>> _chats = {};
  final TextEditingController _input = TextEditingController();
  final FocusNode _inputFocus = FocusNode();
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
    _inputFocus.dispose();
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
      // есть ли у пользователя история — от этого зависит приветствие
      try {
        final last = await Api.lastChatKey();
        if (mounted) {
          setState(() {
            _lastKey = last;
            final i = models.indexWhere((m) => m.key == last);
            if (i >= 0) _lastAI = i;
          });
        }
      } catch (_) {}
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
    _inputFocus.requestFocus(); // можно сразу писать дальше
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

    // Открытый чат занимает всю высоту экрана, остальные экраны прокручиваются
    return AppScaffold(
      header: CustomHeader(selectedIndex: _selectedIndex, onTabSelected: _onTabSelected),
      scroll: !chatOpen,
      showFooter: !(chatOpen && compact),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(key: ValueKey('$_selectedIndex-$_trainingState-${_isTrainingActive || _isTrainingComplete}'), child: _buildContent()),
      ),
    );
  }

  // Переключение между экранами
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 1:
        // тренажёры открываем в «окне» минимальной высоты, чтобы они не прижимались к шапке
        return ConstrainedBox(constraints: BoxConstraints(minHeight: _trainingState == TrainingState.list && !_isTrainingActive && !_isTrainingComplete ? 0 : 440), child: Align(alignment: Alignment.topCenter, child: _buildTrainingsContent()));
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
              selectedColor: buttonDark,
              backgroundColor: surface,
              side: BorderSide(color: borderLight),
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
                themedSvg('assets/icons/square-play.svg', width: 20, height: 20),
                const SizedBox(width: 8),
                Text('Ваши чаты', style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(width: 50),
                AnimatedRotation(turns: _isChatsExpanded ? 0 : 0.5, duration: const Duration(milliseconds: 200), child: themedSvg('assets/icons/chevron-up.svg', width: 10, height: 7)),
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

  // Выбор настроения: при нажатии значок заливается своим цветом
  Widget _buildMoodPicker() {
    const moods = [('annoyed', Color(0xffEFB100)), ('angry', Color(0xffFB2C36)), ('smile', Color(0xff00C16A))];
    return Row(
      children: [
        for (int i = 0; i < moods.length; i++) ...[
          GestureDetector(
            onTap: () => setState(() => _mood = _mood == i ? null : i),
            child: PressableScale(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: _mood == i ? moods[i].$2 : moods[i].$2.withOpacity(0.0), boxShadow: [BoxShadow(color: moods[i].$2.withOpacity(_mood == i ? 0.4 : 0), blurRadius: 12)]),
                child: AnimatedScale(
                  scale: _mood == i ? 1.1 : 1,
                  duration: const Duration(milliseconds: 250),
                  child: SvgPicture.asset('assets/icons/${moods[i].$1}.svg', width: 28, height: 28, colorFilter: _mood == i ? const ColorFilter.mode(white, BlendMode.srcIn) : null),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ],
    );
  }

  // Блок приветствия
  Widget _buildWelcomeContent() {
    final ready = aiModels.isNotEmpty;
    final txt = TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w500);
    final lastIndex = aiModels.indexWhere((m) => m.key == _lastKey);
    final hasHistory = lastIndex >= 0; // «продолжить» показываем только тем, кто уже писал в чаты

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeIn(child: Text('Добрый день, ${userName.isNotEmpty ? userName : 'Гость'}', style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w600))),
        const SizedBox(height: 10),
        FadeIn(delay: const Duration(milliseconds: 100), child: Text('Оцените свое состояние сегодня:', style: txt)),
        const SizedBox(height: 6),
        FadeIn(delay: const Duration(milliseconds: 200), child: _buildMoodPicker()),
        const SizedBox(height: 14),
        if (ready)
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasHistory) ...[
                  Text('Хотите продолжить вашу последнюю сессию?', style: txt),
                  InkWell(
                    onTap: () => _openChat(lastIndex),
                    borderRadius: BorderRadius.circular(4),
                    splashColor: link.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(aiModels[lastIndex].title, style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline, decorationColor: link)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Или выберите другую нейросеть в списке чатов', style: txt),
                ] else
                  Text('Выберите нейросеть в списке чатов и расскажите, как вы себя чувствуете', style: txt),
                const SizedBox(height: 12),
                CustomButton(
                  text: hasHistory ? 'Открыть чат' : 'Начать разговор',
                  color: buttonDark,
                  width: hasHistory ? 120 : 150,
                  height: 36,
                  borderRadius: 6,
                  fontSize: 12,
                  onPressed: () => _openChat(hasHistory ? lastIndex : _lastAI.clamp(0, aiModels.length - 1)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Сообщение в чате (плавно появляется)
  Widget _buildChatMessage(String text, {required bool isUser, Widget? custom}) {
    return FadeIn(
      duration: const Duration(milliseconds: 350),
      offset: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isUser ? ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 24, height: 24, fit: BoxFit.cover)) : SvgPicture.asset('assets/icons/ai_avatar.svg', width: 24, height: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: isUser ? background : bubbleColor.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
              child: custom ?? SelectableText(text, style: TextStyle(color: message, fontSize: 13, fontWeight: FontWeight.w400, height: 1.4)),
            ),
          ),
        ],
      ),
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
              themedSvg('assets/icons/square-play.svg', width: 48, height: 48),
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
          for (int i = 0; i < currentChat.length; i++) ...[KeyedSubtree(key: ValueKey('$key-$i'), child: _buildChatMessage(currentChat[i].text, isUser: currentChat[i].isUser)), const SizedBox(height: 12)],
          if (_isSending) ...[_buildChatMessage('', isUser: false, custom: const TypingDots()), const SizedBox(height: 12)],
        ],
      );
    }

    final box = Container(
      decoration: BoxDecoration(color: surface, border: Border.all(color: borderLight), borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: borderLight))),
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
      decoration: BoxDecoration(border: Border(top: BorderSide(color: borderLight))),
      child: Row(
        children: [
          Expanded(
            child: InputBox(controller: _input, focusNode: _inputFocus, hint: 'Введите сообщение...', height: 40, fontSize: 13, maxLength: 2000, maxLines: 4, textInputAction: TextInputAction.send, onSubmitted: (_) => _sendMessage()),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _isSending ? null : _sendMessage,
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.white.withOpacity(0.3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
            AnimatedContainer(duration: const Duration(milliseconds: 250), width: 2, height: 32, color: isSelected ? primaryText : borderLight),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 250), style: TextStyle(color: isSelected ? primaryText : grey, fontSize: 14, fontWeight: FontWeight.w600), child: Text(name)),
            ),
          ],
        ),
      ),
    );
  }

  // Карточка тренажёра
  Widget _trainingCard(String name, String description, {required String width, required int index, VoidCallback? onStart}) {
    return FadeIn(
      delay: Duration(milliseconds: 120 * index),
      child: _HoverCard(
      child: Container(
      width: width == 'full' ? double.infinity : 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: surface, border: Border.all(color: borderLight), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: surfaceSoft, borderRadius: BorderRadius.circular(6)),
            child: Text('2 мин', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: message)),
          ),
          const SizedBox(height: 8),
          Text(name, style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: grey, fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          CustomButton(text: 'Начать', fontSize: 12, color: buttonDark, width: 60, height: 28, borderRadius: 6, onPressed: onStart ?? () {}),
        ],
      ),
      ),
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
          index: 0,
          onStart: () => setState(() => _trainingState = TrainingState.breathing),
        ),
        _trainingCard(
          'Тренажер “Копилка благодарностей”',
          'Назовите три хорошие вещи за сегодня и смотрите, как они наполняют банку светом. Формирует привычку замечать хорошее, что особенно важно в тяжёлые периоды.',
          width: w,
          index: 1,
          onStart: () => setState(() => _trainingState = TrainingState.gratitude),
        ),
        _trainingCard(
          'Тренажер “Дневник чувств”',
          'Сложно справиться с эмоцией, если она не названа. Используйте этот тренажер, чтобы точно определить свое текущее состояние, понять его причину и снизить интенсивность переживаний через осознанность.',
          width: w,
          index: 2,
          onStart: () => setState(() => _trainingState = TrainingState.feelings),
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
                color: surface,
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

    if (_trainingState == TrainingState.gratitude) {
      return GratitudeTrainer(onExit: () => setState(() => _trainingState = TrainingState.list));
    }
    if (_trainingState == TrainingState.feelings) {
      return FeelingsTrainer(onExit: () => setState(() => _trainingState = TrainingState.list));
    }

    // Стартовый экран тренажёра
    if (_trainingState == TrainingState.breathing) {
      return _buildTrainingStart();
    }

    // Список тренажёров
    return _buildTrainingsList();
  }
}

// Карточка, которая слегка приподнимается при наведении
class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(_hover ? 0.10 : 0.0), blurRadius: 18, offset: const Offset(0, 8))]),
        child: widget.child,
      ),
    );
  }
}

// Три прыгающие точки («ИИ печатает»)
class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Transform.translate(
                  offset: Offset(0, -5 * math.max(0, math.sin((_c.value - i * 0.15) * 2 * math.pi))),
                  child: Container(width: 7, height: 7, decoration: BoxDecoration(color: grey, shape: BoxShape.circle)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
