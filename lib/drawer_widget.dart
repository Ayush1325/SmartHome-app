import 'package:flutter/material.dart';
import 'controller.dart';
import 'weather_page.dart';
import 'firebase_helper.dart';

class DrawerWidget extends StatelessWidget {

  final FirebaseHelper firebaseHelper;
  DrawerWidget({Key key, this.firebaseHelper});

  @override
  Widget build(BuildContext context) {
    var list = [['Home', WeatherPage(firebaseHelper: firebaseHelper,)], ['Controls', Controller(firebaseHelper: firebaseHelper,)]];
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index][0]),
          onTap: () {
            Navigator.pop(context);
//            Navigator.pushReplacement(context, list[index][1]);
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => list[index][1]));
            },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: list.length,
    );
  }
}