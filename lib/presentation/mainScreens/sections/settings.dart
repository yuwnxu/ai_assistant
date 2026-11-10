import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/data/api.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/app_scaffold.dart';
import 'package:ai_assistant/presentation/uiKit/app_widgets.dart';
import 'package:ai_assistant/presentation/uiKit/custom_header.dart';

// Экран Настройки
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isDataCollectionOn = false;
  bool _isHistoryOn = true;
  bool _isSaving = false;
  String _selectedTone = userTone;
  late final TextEditingController _nameController = TextEditingController(text: userName);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await Api.updateProfile(name: _nameController.text.trim(), tone: _selectedTone);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Настройки сохранены')));
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    await Api.logout();
    if (mounted) navToSignIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: CustomHeader(selectedIndex: -1, onTabSelected: (i) => navToHome(context, tab: i)),
      child: FadeIn(child: Center(child: _buildContent())),
    );
  }

  Widget _toggle(bool value, VoidCallback onTap, String title, String subtitle) {
    return Row(
      children: [
        AppSwitch(value: value, onTap: onTap),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w600)),
              Text(subtitle, style: TextStyle(color: grey, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _toneButton(String tone) {
    final selected = _selectedTone == tone;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => setState(() => _selectedTone = tone),
        borderRadius: BorderRadius.circular(6),
        splashColor: green.withOpacity(0.2),
        child: Container(
          width: 170,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? primaryText : buttonDarkSoft,
            border: Border.all(color: selected ? buttonDark : borderInput),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tone, style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
              if (selected) SvgPicture.asset('assets/icons/check.svg', width: 10, height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 404),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: surface, border: Border.all(color: borderLight), borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 48, height: 48, fit: BoxFit.cover))),
            const SizedBox(height: 10),
            Text('Имя', style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w600)),
            Text('Введите имя, по которому к Вам будет обращаться ИИ', style: TextStyle(color: grey, fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            InputBox(controller: _nameController, hint: 'Имя', height: 38, maxLength: 60),
            const SizedBox(height: 14),
            _toggle(_isDataCollectionOn, () => setState(() => _isDataCollectionOn = !_isDataCollectionOn), 'Сбор аналитических данных', 'Это поможет нам сделать проект лучше'),
            const SizedBox(height: 12),
            _toggle(_isHistoryOn, () => setState(() => _isHistoryOn = !_isHistoryOn), 'Хранить историю', 'Это поможет нам лучше анализировать диалоги'),
            const SizedBox(height: 16),
            Text('Тон общения ИИ', style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _toneButton('Поддерживающий'),
            _toneButton('Аналитический'),
            InkWell(
              onTap: _logout,
              borderRadius: BorderRadius.circular(6),
              splashColor: error.withOpacity(0.2),
              child: Container(
                width: 170,
                height: 32,
                decoration: BoxDecoration(color: surface, border: Border.all(color: error), borderRadius: BorderRadius.circular(6)),
                child: Center(child: Text('Выйти из аккаунта', style: TextStyle(color: error, fontSize: 12, fontWeight: FontWeight.w600))),
              ),
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: borderLight),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: _isSaving ? null : _save,
                borderRadius: BorderRadius.circular(6),
                splashColor: green.withOpacity(0.2),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: surface, border: Border.all(color: borderInput), borderRadius: BorderRadius.circular(6)),
                  child: Center(child: Text(_isSaving ? 'Сохраняем...' : 'Сохранить', style: TextStyle(color: message, fontSize: 13, fontWeight: FontWeight.w500))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
