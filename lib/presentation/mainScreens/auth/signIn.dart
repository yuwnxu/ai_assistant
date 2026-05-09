import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/custom_textfield.dart';

//Экран Входа
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isChecked = false;
  bool _isLoading = false;
  String? _loginError;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    setState(() {
      _loginError = null;
    });

    if (_emailController.text.isEmpty) {
      setState(() => _loginError = 'Введите email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _loginError = 'Введите пароль');
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = await loginUser(_emailController.text.trim(), _passwordController.text);
      if (success) {
        await setCurrentUser(_emailController.text.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Вход выполнен!')));
          navToHome(context);
        }
      } else {
        setState(() => _loginError = 'Неверный email или пароль');
      }
    } catch (e) {
      setState(() => _loginError = 'Ошибка при входе');
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
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 25),
                    InkWell(
                      onTap: () => navToSignIn(context),
                      borderRadius: BorderRadius.circular(4),
                      splashColor: green.withOpacity(0.2),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text(
                          'Зарегистрируйтесь или войдите',
                          style: TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 100),
                    SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Container(width: 608, height: 1, color: const Color(0xffE2E8F0)),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 384,
                    decoration: BoxDecoration(
                      color: white,
                      border: Border.all(color: const Color(0xffE2E8F0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 25),
                        SvgPicture.asset('assets/icons/user.svg', width: 20, height: 25),
                        const SizedBox(height: 10),
                        Text(
                          'Вход',
                          style: TextStyle(color: primaryText, fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Введите данные для входа',
                          style: TextStyle(color: grey, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 25),
                        // Google
                        InkWell(
                          onTap: () => {},
                          borderRadius: BorderRadius.circular(5),
                          splashColor: green.withOpacity(0.2),
                          child: Container(
                            width: 336,
                            height: 32,
                            decoration: BoxDecoration(
                              color: background,
                              border: Border.all(color: const Color(0xffCAD5E2)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20),
                                const SizedBox(width: 6),
                                Text(
                                  'Google',
                                  style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 142, height: 1, color: const Color(0xffE2E8F0)),
                            const SizedBox(width: 12),
                            Text(
                              'Или',
                              style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(width: 12),
                            Container(width: 142, height: 1, color: const Color(0xffE2E8F0)),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(type: TextFieldType.text, controller: _emailController, borderRadius: 5, colorCursor: green, title: 'Email', hintText: 'Введите адрес эл. почты', width: 336, height: 32),
                              const SizedBox(height: 16),
                              CustomTextField(type: TextFieldType.password, controller: _passwordController, borderRadius: 5, colorCursor: green, title: 'Пароль', hintText: 'Введите пароль', width: 336, height: 32),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: Transform.scale(
                                      scale: 0.9,
                                      child: Checkbox(
                                        value: _isChecked,
                                        onChanged: (value) => setState(() => _isChecked = value ?? false),
                                        checkColor: white,
                                        activeColor: primaryText,
                                        side: const BorderSide(color: Color(0xffCAD5E2)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Запомните меня',
                                    style: TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        if (_loginError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              _loginError!,
                              style: TextStyle(color: error, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        const SizedBox(height: 10),
                        _isLoading ? CircularProgressIndicator(color: green) : CustomButton(text: 'Войти', color: green, width: 336, height: 40, borderRadius: 8, fontSize: 16, onPressed: _handleLogin),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () => navToReg(context),
                          borderRadius: BorderRadius.circular(4),
                          splashColor: link.withOpacity(0.2),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            child: Text(
                              'Еще нет аккаунта?',
                              style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const CustomFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
