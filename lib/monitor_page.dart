import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonitorPage extends StatefulWidget {

  @override
  _MonitorPage createState() => _MonitorPage();
}

class _MonitorPage extends State<MonitorPage> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Flame',
                  style: TextStyle(
                    fontSize: 24
                  ),
                ),
              ),
              StreamBuilder(
                initialData: {"flame": false},
                stream: Firestore.instance.collection('home').document('monitor').snapshots(),
                builder: (context, snapshots) {
                  return ImageIcon(
                          AssetImage("images/sensor.png"),
                          size: 48,
                          color: snapshots.data['flame']? Colors.yellow : Colors.black,
                  );
                }
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: 1,
    );
  }
}