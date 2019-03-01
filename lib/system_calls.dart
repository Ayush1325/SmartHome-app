import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SystemCalls extends StatefulWidget
{

  @override
  _SystemCalls createState() => _SystemCalls();
}

class _SystemCalls extends State<SystemCalls>
{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(
                    "Power Off",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  )),
                  IconButton(
                    icon: ImageIcon(
                      AssetImage("images/power_off.png"),
                      size: 48,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Firestore.instance.collection('home').document('rpiControls').updateData({"powerOff": true});
                    },
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}