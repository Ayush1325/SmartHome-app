import 'package:flutter/material.dart';
import 'weather_page.dart';
import 'controller.dart';
import 'firebase_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseHelper _firebaseHelper = FirebaseHelper();
    _firebaseHelper.context = context;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder> {
        "/home": (BuildContext context) => WeatherPage(),
        "/controls": (BuildContext context) => Controller(),
      },
      home: WeatherPage(firebaseHelper: _firebaseHelper,),
    );
  }
}