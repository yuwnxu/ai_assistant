import 'package:flutter/material.dart';
import 'package:ai_assistant/presentation/mainScreens/mainPage.dart';
import 'package:google_fonts/google_fonts.dart';

//Точка входа
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
      home: MainPage(),
    );
  }
}
