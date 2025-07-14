import 'package:flutter/material.dart';
import 'package:itsu/data.dart';
import 'package:itsu/widgets/home_page.dart';

const dayNames = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday",
};

const millisecondsinaday = (1000 * 60 * 60 * 24);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadUserData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark).copyWith(
        colorScheme: ColorScheme.dark(
          surface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: "home",
      routes: {
        "home": (context) => HomePage(),
        // "login": LoginPage(),
      },
    );
  }
}
