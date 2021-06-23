import 'package:flutter/material.dart';
import 'package:energie4you/Helpers/hex_color.dart';


import 'Screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Energie4You',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: colorFromHex(context, '#397f99'),
      ),
      home: HomeScreen(),
    );
  }
}
