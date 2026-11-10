import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/custom_textfield.dart';
import 'package:ai_assistant/presentation/mainScreens/auth/auth_shell.dart';
import 'package:ai_assistant/data/api.dart';

//Экран Входа
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isLoading = false;
  String? _loginError;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return setState(() => _loginError = 'Введите email');
    if (_passwordController.text.isEmpty) return setState(() => _loginError = 'Введите пароль');

    setState(() {
      _loginError = null;
      _isLoading = true;
    });

    try {
      await Api.login(email, _passwordController.text);
      if (mounted) navToHome(context);
    } on ApiException catch (e) {
      if (mounted) setState(() => _loginError = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      card: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/user.svg', width: 20, height: 25),
          const SizedBox(height: 10),
          Text('Вход', style: TextStyle(color: primaryText, fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text('Введите данные для входа', style: TextStyle(color: grey, fontSize: 16, fontWeight: FontWeight.w400)),
          const SizedBox(height: 25),
          const GoogleOrDivider(),
          const SizedBox(height: 25),
          CustomTextField(type: TextFieldType.text, controller: _emailController, borderRadius: 5, colorCursor: green, title: 'Email', hintText: 'Введите адрес эл. почты', height: 40),
          const SizedBox(height: 16),
          CustomTextField(type: TextFieldType.password, controller: _passwordController, borderRadius: 5, colorCursor: green, title: 'Пароль', hintText: 'Введите пароль', height: 40),
          const SizedBox(height: 20),
          if (_loginError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_loginError!, textAlign: TextAlign.center, style: TextStyle(color: error, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          _isLoading ? CircularProgressIndicator(color: green) : CustomButton(text: 'Войти', color: green, width: double.infinity, height: 44, borderRadius: 8, fontSize: 16, onPressed: _handleLogin),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => navToReg(context),
            borderRadius: BorderRadius.circular(4),
            splashColor: link.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Text('Еще нет аккаунта?', style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );
  }
}
