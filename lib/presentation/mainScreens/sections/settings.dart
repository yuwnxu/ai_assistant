import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/domain/globals.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/home.dart';
import '../../uiKit/custom_footer.dart';

// Экран Настройки
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isDataCollectionOn = false;
  bool _isHistoryOn = true;
  String _selectedTone = 'Поддерживающий';

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
                _buildHeader(),
                SizedBox(height: 20),
                Container(width: 856, height: 1, color: Color(0xffE2E8F0)),
                SizedBox(height: 20),
                Expanded(child: _buildContent()),
                SizedBox(height: 150),
                CustomFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          },
          borderRadius: BorderRadius.circular(4),
          splashColor: green.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              'Главная',
              style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(width: 25),
        InkWell(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          },
          borderRadius: BorderRadius.circular(4),
          splashColor: green.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              'Тренажеры',
              style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(width: 25),
        Text(
          'Правовая информация',
          style: TextStyle(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 150),
        SvgPicture.asset('assets/icons/sun.svg', width: 20, height: 20),
        SizedBox(width: 16),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 20, height: 20, fit: BoxFit.cover)),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Center(
      child: Container(
        width: 404,
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: Color(0xffE2E8F0), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipOval(child: Image.asset('assets/icons/user_avatar.jpg', width: 48, height: 48, fit: BoxFit.cover)),
              ),
              SizedBox(height: 10),
              Text(
                'Имя',
                style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Text(
                'Введите имя, по которому к Вам будет обращаться ИИ',
                style: TextStyle(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Container(
                width: 336,
                height: 22,
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: Color(0xffCAD5E2), width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: TextEditingController(text: userName),
                  decoration: InputDecoration(
                    hintText: 'Имя',
                    hintStyle: TextStyle(color: hintText, fontSize: 12, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    isDense: true,
                  ),
                  style: TextStyle(color: primaryText, fontSize: 12),
                  onChanged: (value) {
                    userName = value;
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDataCollectionOn = !_isDataCollectionOn;
                      });
                    },
                    child: SvgPicture.asset(_isDataCollectionOn ? 'assets/icons/switch-on.svg' : 'assets/icons/switch-off.svg', width: 28, height: 16),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Сбор аналитических данных',
                        style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Это поможет нам сделать проект лучше',
                        style: TextStyle(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isHistoryOn = !_isHistoryOn;
                      });
                    },
                    child: SvgPicture.asset(_isHistoryOn ? 'assets/icons/switch-on.svg' : 'assets/icons/switch-off.svg', width: 28, height: 16),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Хранить историю',
                        style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Это поможет нам лучше анализировать диалоги',
                        style: TextStyle(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Тон общения ИИ',
                style: TextStyle(color: message, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedTone = 'Поддерживающий';
                  });
                },
                borderRadius: BorderRadius.circular(6),
                splashColor: green.withOpacity(0.2),
                child: Container(
                  width: 145,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _selectedTone == 'Поддерживающий' ? primaryText : Color(0xE50F172B),
                    border: Border.all(color: _selectedTone == 'Поддерживающий' ? primaryText : Color(0xffCAD5E2), width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Поддерживающий',
                          style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        if (_selectedTone == 'Поддерживающий') SvgPicture.asset('assets/icons/check.svg', width: 10, height: 8),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedTone = 'Аналитический';
                  });
                },
                borderRadius: BorderRadius.circular(6),
                splashColor: green.withOpacity(0.2),
                child: Container(
                  width: 130,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _selectedTone == 'Аналитический' ? primaryText : Color(0xE50F172B),
                    border: Border.all(color: _selectedTone == 'Аналитический' ? primaryText : Color(0xffCAD5E2), width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Аналитический',
                          style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        if (_selectedTone == 'Аналитический') SvgPicture.asset('assets/icons/check.svg', width: 10, height: 8),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  navToSignIn(context);
                },
                borderRadius: BorderRadius.circular(6),
                splashColor: error.withOpacity(0.2),
                child: Container(
                  width: 130,
                  height: 24,
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: error, width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      'Выйти из аккаунта',
                      style: TextStyle(color: error, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28),
              Container(width: 400, height: 1, color: Color(0xffE2E8F0)),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Настройки сохранены')));
                    },
                    borderRadius: BorderRadius.circular(6),
                    splashColor: green.withOpacity(0.2),
                    child: Container(
                      width: 81,
                      height: 24,
                      decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: Color(0xffCAD5E2), width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          'Сохранить',
                          style: TextStyle(color: message, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
