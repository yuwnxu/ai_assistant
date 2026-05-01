import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/custom_textfield.dart';

//Экран Вход

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isChecked = false;

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
                    SizedBox(width: 25),
                    GestureDetector(
                      onTap: () {
                        navToSignIn(context);
                      },
                      child: Text(
                        'Зарегистрируйтесь или войдите',
                        style: TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0),
                      ),
                    ),
                    SizedBox(width: 100),
                    SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
                  ],
                ),
                SizedBox(height: 20),
                Container(width: 608, height: 1, color: Color(0xffE2E8F0)),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 548,
                    width: 384,
                    decoration: BoxDecoration(
                      color: white,
                      border: Border.all(color: Color(0xffE2E8F0), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 25),
                        SvgPicture.asset('assets/icons/user.svg', width: 20, height: 25),
                        SizedBox(height: 10),
                        Text(
                          'Вход',
                          style: TextStyle(color: primaryText, fontSize: 20, fontWeight: .w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Введите данные для входа',
                          style: TextStyle(color: grey, fontSize: 16, fontWeight: .w400),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: 336,
                          height: 32,
                          decoration: BoxDecoration(
                            color: background,
                            border: Border.all(color: Color(0xffCAD5E2), width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20),
                              SizedBox(width: 6),
                              Text(
                                'Google',
                                style: TextStyle(color: message, fontSize: 14, fontWeight: .w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 142, height: 1, color: Color(0xffE2E8F0)),
                            SizedBox(width: 12),
                            Text(
                              'Или',
                              style: TextStyle(color: message, fontSize: 14, fontWeight: .w400),
                            ),
                            SizedBox(width: 12),
                            Container(width: 142, height: 1, color: Color(0xffE2E8F0)),
                          ],
                        ),
                        SizedBox(height: 25),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(type: TextFieldType.text, controller: emailController, borderRadius: 5, colorCursor: green, title: 'Email', hintText: 'Введите адрес эл. почты', width: 336, height: 32),
                                SizedBox(height: 16),
                                CustomTextField(type: TextFieldType.password, controller: passwordController, borderRadius: 5, colorCursor: green, title: 'Password', hintText: 'Введите пароль', width: 336, height: 32),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Transform.scale(
                                        scale: 0.9,
                                        child: Checkbox(
                                          value: _isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isChecked = value ?? false;
                                            });
                                          },
                                          checkColor: white,
                                          activeColor: primaryText,
                                          side: const BorderSide(color: Color(0xffCAD5E2), width: 1),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
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
                        ),
                        SizedBox(height: 25),
                        CustomButton(
                          text: 'Войти',
                          color: green,
                          width: 336,
                          height: 32,
                          borderRadius: 6,
                          onPressed: () {
                            navToBoard1(context);
                          },
                        ),
                        SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            navToReg(context);
                          },
                          child: Text(
                            'Еще нет аккаунта?',
                            style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline, decorationColor: link, decorationThickness: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80),
                CustomFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
