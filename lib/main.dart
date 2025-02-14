import 'package:firebase_core/firebase_core.dart';
import 'package:double_partner_test/presentation/auth/views/login_screen.dart';
import 'package:flutter/material.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Double partner Test',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginView()
      },
    );
  }
}