import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/uiKit/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';
import '../../uiKit/custom_textfield.dart';

// Экран Регистрации

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: SingleChildScrollView(
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
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      height: 672,
                      width: 384,
                      decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: Color(0xffE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 25),
                            SvgPicture.asset('assets/icons/user.svg', width: 20, height: 25),
                            SizedBox(height: 10),
                            Text(
                              'Регистрация',
                              style: TextStyle(color: primaryText, fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Введите данные для доступа к сервису',
                              style: TextStyle(color: grey, fontSize: 16, fontWeight: FontWeight.w400),
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
                                    style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w500),
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
                                  style: TextStyle(color: message, fontSize: 14, fontWeight: FontWeight.w400),
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
                                    // Email
                                    CustomTextField(type: TextFieldType.text, controller: emailController, borderRadius: 5, colorCursor: green, title: 'Email', hintText: 'Введите адрес эл. почты', width: 336, height: 32),
                                    SizedBox(height: 16),
                                    CustomTextField(type: TextFieldType.password, controller: passwordController, borderRadius: 5, colorCursor: green, title: 'Password', hintText: 'Введите пароль', width: 336, height: 32),
                                    SizedBox(height: 8),
                                    Text(
                                      'Не менее 8 символов, включая цифры',
                                      style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(height: 20),
                                    CustomTextField(type: TextFieldType.password, controller: TextEditingController(), borderRadius: 5, colorCursor: green, title: 'Повторите пароль', hintText: 'Повторите пароль', width: 336, height: 32),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            CustomButton(text: 'Продолжить', color: green, width: 336, height: 32, borderRadius: 6, onPressed: () {navToBoard1(context);}),
                            SizedBox(height: 24),
                            GestureDetector(
                              onTap: () {
                                navToSignIn(context);
                              },
                              child: Text(
                                'Уже есть аккаунт?',
                                style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline, decorationColor: link, decorationThickness: 1),
                              ),
                            ),
                            SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(text: 'Регистрируясь, Вы принимаете\n'),
                                  TextSpan(
                                    text: 'Пользовательское соглашение',
                                    style: TextStyle(color: link, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline, decorationColor: link, decorationThickness: 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/id_card.svg', width: 56, height: 56),
                      SizedBox(width: 16),
                      Container(width: 184, height: 2, color: grey),
                      SizedBox(width: 16),
                      SvgPicture.asset('assets/icons/settings.svg', width: 21, height: 23),
                      SizedBox(width: 16),
                      Container(width: 184, height: 2, color: grey),
                      SizedBox(width: 16),
                      SvgPicture.asset('assets/icons/check.svg', width: 19, height: 13),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Регистрация',
                            style: TextStyle(color: message, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Зарегистрируйтесь в сервисе',
                            style: TextStyle(color: grey, fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Настройки',
                            style: TextStyle(color: message, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Настройте предпочтения и\n    конфиденциальность',
                            style: TextStyle(color: grey, fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Готово',
                            style: TextStyle(color: message, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Приятного пользования!',
                            style: TextStyle(color: grey, fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  CustomFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
