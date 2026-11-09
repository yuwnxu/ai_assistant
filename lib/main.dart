import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/mainScreens/mainPage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

// Точка входа
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI_Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.dmSansTextTheme()),
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const MobileDevelopmentPage();
          }

          return MainPage();
        },
      ),
    );
  }
}

class MobileDevelopmentPage extends StatefulWidget {
  const MobileDevelopmentPage({super.key});

  @override
  State<MobileDevelopmentPage> createState() => _MobileDevelopmentPageState();
}

class _MobileDevelopmentPageState extends State<MobileDevelopmentPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: 0.45, end: 0.9).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 430),
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 42),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Color(0xffE2E8F0)),
              boxShadow: [BoxShadow(color: Color(0xff0F172B).withOpacity(0.05), blurRadius: 35, offset: Offset(0, 12))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: green.withOpacity(0.07 * _fadeAnimation.value)),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(color: green.withOpacity(0.10), borderRadius: BorderRadius.circular(30)),
                            child: SvgPicture.asset('assets/icons/smile.svg', width: 40, height: 40),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(color: breathSoft, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(color: green, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'В РАЗРАБОТКЕ',
                        style: TextStyle(color: Color(0xff008F4C), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22),
                Text(
                  'Вернитесь позже',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primaryText, fontSize: 27, fontWeight: FontWeight.w700, height: 1.2),
                ),
                SizedBox(height: 14),
                Text(
                  'Мы работаем над адаптацией AI Assistant '
                  'для смартфонов, чтобы пользоваться '
                  'сервисом было удобно с любого устройства.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: grey, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 28),
                Container(height: 1, color: Color(0xffE2E8F0)),
                SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/sun.svg', width: 18, height: 18, color: green),
                    SizedBox(width: 9),
                    Text(
                      'Пока доступно\nтолько на компьютерах',
                      style: TextStyle(color: message, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 26),
                Text(
                  'AI ASSISTANT',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: border, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
