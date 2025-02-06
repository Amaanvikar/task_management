import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/screens/task_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: _buildAppTheme(),
      home: TaskListScreen(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      primaryColor: Color(0xFF01442C),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Color(0xFF01442C),
        elevation: 0,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFF01442C),
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      // You can also add other color schemes
      colorScheme: ColorScheme.light(
        primary: Color(0xFF01442C),
        secondary: Colors.green,
        surface: Colors.white,
        background: Colors.grey[100]!,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
      ),
    );
  }
}
