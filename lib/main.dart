import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resto/models/menu_model.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_menu_screen.dart';
import 'screens/transaction_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final someMenu = MenuModel(
    id: '1',
    name: 'Sample Menu',
    description: 'This is a sample menu description',
    price: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Cashier App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/add-menu': (context) => AddMenuScreen(),
        '/transaction': (context) => TransactionScreen(menu: someMenu),
      },
    );
  }
}
