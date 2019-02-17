import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {

  @override
  _WeatherPage createState() => _WeatherPage();
}

class _WeatherPage extends State<StatefulWidget> {

  IconData _iconData = Icons.wb_sunny;
  double _temp = 0.0;
  int _hmd = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _iconData,
              size: 300,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    _temp.toString() + "\u00b0" + "C",
                    style: TextStyle(
                      fontSize: 52,
                    ),
                  ),
                  Text(
                    _hmd.toString() + "%",
                    style: TextStyle(
                      fontSize: 52,
                    ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}