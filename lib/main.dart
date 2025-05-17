import 'package:flutter/material.dart';
import 'package:php_note_demo/auth/sign_up.dart';
import 'package:php_note_demo/home.dart';
import 'package:php_note_demo/auth/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute:
          (sharedPreferences.getString('id') ?? '').isEmpty
              ? '/sign-in'
              : '/home',
      routes: {
        '/home': (context) => MyHomePage(),
        '/sign-in': (_) => SignIn(),
        '/sign-up': (_) => SignUp(),
      },
    );
  }
}
