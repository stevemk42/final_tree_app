import 'package:final_tree_app/pages/account_page.dart';
import 'package:final_tree_app/pages/home_page.dart';
import 'package:final_tree_app/pages/login_page.dart';
import 'package:final_tree_app/pages/search_page.dart';
import 'package:final_tree_app/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://hpwngmuhfqzeutupnbye.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhwd25nbXVoZnF6ZXV0dXBuYnllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTcxNjA0MjIsImV4cCI6MjAzMjczNjQyMn0.gSy59Aeilk0XryaFndZcmQm6JpbR6cRCNYb2JF_3XIY',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree app',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/search': (_) => const SearchPage(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}
