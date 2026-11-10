import 'package:flutter/material.dart';
import 'package:ai_assistant/data/api.dart';
import 'package:ai_assistant/presentation/mainScreens/mainPage.dart';
import 'package:ai_assistant/presentation/mainScreens/sections/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';

// Точка входа
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.init(); // читаем адрес сервера и сохранённый токен
  await loadTheme(); // светлая или тёмная тема
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI_Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: isDarkMode ? Brightness.dark : Brightness.light),
        textTheme: GoogleFonts.dmSansTextTheme(isDarkMode ? ThemeData.dark().textTheme : ThemeData.light().textTheme),
      ),
      home: const StartPage(),
    );
  }
}

// Если пользователь уже входил — сразу открываем главную, иначе — приветственный экран
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late final Future<bool> _session = Api.restoreSession();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _session,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: background,
            body: Center(child: CircularProgressIndicator(color: green)),
          );
        }
        return snapshot.data == true ? const Home() : const MainPage();
      },
    );
  }
}
