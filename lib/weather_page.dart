import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer_widget.dart';
import 'firebase_helper.dart';

class WeatherPage extends StatefulWidget {

  final FirebaseHelper firebaseHelper;
  WeatherPage({Key key, this.firebaseHelper});
  @override
  _WeatherPage createState() => _WeatherPage();
}

class _WeatherPage extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: Drawer(
        child: DrawerWidget(firebaseHelper: widget.firebaseHelper,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          initialData: {'cloud': false, 'rain': false, 'temp': 0, 'humidity': 0},
          stream: Firestore.instance.collection('home').document('weather').snapshots(),
          builder: (context, snapshots) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  weatherIcon(snapshots.data['cloud'], snapshots.data['rain']),
                  height: 300,
                  width: 300,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        snapshots.data['temp'].toString() + "\u00b0" + "C",
                        style: TextStyle(
                          fontSize: 52,
                        ),
                      ),
                      Text(
                        snapshots.data['humidity'].toString() + "%",
                        style: TextStyle(
                          fontSize: 52,
                        ),),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.firebaseHelper.context = context;
  }

  String weatherIcon(bool cloud, bool rain) {
    if(rain){
      return 'images/rain.png';
    } else if (cloud) {
      return 'images/cloudy.png';
    }
    return 'images/sunny.png';
  }

}