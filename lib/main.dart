import 'package:double_partner_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:double_partner_test/presentation/pages/register_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/injection/injection_container.dart' as di;
import 'package:double_partner_test/presentation/pages/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>())
      ],
      child: MaterialApp(
        title: 'Double partner Test',
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/register': (context) => RegisterView()
        },
      )
      );
  }
}