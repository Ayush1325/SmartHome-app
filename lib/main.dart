import 'package:flutter/material.dart';
import 'weather_page.dart';
import 'device_controls.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder> {
        "/home": (BuildContext context) => WeatherPage(),
        "/devices": (BuildContext context) => DeviceControls(),
      },
      home: WeatherPage(),
    );
  }
}