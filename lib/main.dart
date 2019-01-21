import 'package:Tinder_Matching/route/home_screen.dart';
import 'package:Tinder_Matching/route/messages_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.orangeAccent,
      ),
      routes: routes,
    );
  }
}

final routes = {
  '/': (BuildContext context) => HomeScreen(),
  '/message': (BuildContext context) => MessagesScreen(),
};
