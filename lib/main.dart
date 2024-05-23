import 'package:chatbuddy_ai_flutter/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatBuddy AI',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(backgroundColor: Colors.black)),
      home: HomePage(),
    );
  }
}
