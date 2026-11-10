import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/app_widgets.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../uiKit/custom_textfield.dart';
import 'package:ai_assistant/data/api.dart';
import 'package:ai_assistant/presentation/mainScreens/auth/auth_shell.dart';
import 'package:ai_assistant/presentation/uiKit/steps.dart';

//Экран Регистрации
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _registerError;

  bool _isLoading = false;

  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = 'Введите email';
        isValid = false;
      } else if (!_isValidEmail(_emailController.text)) {
        _emailError = 'Введите корректный email';
        isValid = false;
      } else {
        _emailError = null;
      }

      if (_passwordController.text.isEmpty) {
        _passwordError = 'Введите пароль';
        isValid = false;
      } else if (!_isValidPassword(_passwordController.text)) {
        _passwordError = 'Пароль должен быть не менее 6 символов';
        isValid = false;
      } else {
        _passwordError = null;
      }

      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Подтвердите пароль';
        isValid = false;
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = 'Пароли не совпадают';
        isValid = false;
      } else {
        _confirmPasswordError = null;
      }
    });

    return isValid;
  }

  Future<void> _handleRegister() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
      _registerError = null;
    });

    try {
      await Api.register(_emailController.text.trim(), _passwordController.text);
      if (mounted) navToBoard1(context);
    } on ApiException catch (e) {
      if (mounted) setState(() => _registerError = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      bottom: const OnboardingSteps(step: 0),
      card: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          themedSvg('assets/icons/user.svg', width: 20, height: 25),
          const SizedBox(height: 10),
          Text('Регистрация', style: TextStyle(color: primaryText, fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text('Введите данные для доступа к сервису', textAlign: TextAlign.center, style: TextStyle(color: grey, fontSize: 16, fontWeight: FontWeight.w400)),
          const SizedBox(height: 25),
          const GoogleOrDivider(),
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(type: TextFieldType.text, controller: _emailController, borderRadius: 5, colorCursor: green, title: 'Email', hintText: 'Введите адрес эл. почты', height: 40, errorText: _emailError),
                const SizedBox(height: 16),
                CustomTextField(type: TextFieldType.password, controller: _passwordController, borderRadius: 5, colorCursor: green, title: 'Пароль', hintText: 'Введите пароль', height: 40, errorText: _passwordError),
                const SizedBox(height: 8),
                Text('Не менее 6 символов', style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w400)),
                const SizedBox(height: 20),
                CustomTextField(type: TextFieldType.password, controller: _confirmPasswordController, borderRadius: 5, colorCursor: green, title: 'Повторите пароль', hintText: 'Повторите пароль', height: 40, errorText: _confirmPasswordError),
              ],
            ),
          ),
          const SizedBox(height: 25),
          if (_registerError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_registerError!, textAlign: TextAlign.center, style: TextStyle(color: error, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          _isLoading ? CircularProgressIndicator(color: green) : CustomButton(text: 'Зарегистрироваться', color: green, width: double.infinity, height: 44, borderRadius: 8, fontSize: 14, onPressed: _handleRegister),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => navToSignIn(context),
            borderRadius: BorderRadius.circular(4),
            splashColor: link.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Text('Уже есть аккаунт?', style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w400),
              children: [
                const TextSpan(text: 'Регистрируясь, Вы принимаете '),
                TextSpan(text: 'Пользовательское соглашение', style: TextStyle(color: link, fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
