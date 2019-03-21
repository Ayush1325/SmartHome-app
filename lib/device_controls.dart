import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'device_data.dart';
import 'door_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:toast/toast.dart';

class DeviceControls extends StatefulWidget {

  @override
  _DeviceControls createState() => _DeviceControls();
}

class _DeviceControls extends State<DeviceControls> {

  var list1 = [DeviceData('light1', false, 0, 'images/light-bulb.png'), DeviceData('light2', false, 0, 'images/light-bulb.png'), DeviceData('fan', false, 0, 'images/fan.png')];
  var list2 = [DoorData("door", false, "images/door_open.png", "images/door_closed.png")];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child: Text(
                            list1[index].deviceName,
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          )),
                          IconButton(
                            icon: ImageIcon(
                              AssetImage(list1[index].iconData),
                              size: 48,
                              color: list1[index].toggleState? Colors.amberAccent : Colors.black,
                            ),
                            onPressed: () {
                              if(list1[index].toggleState){
                                toggleDevice(list1[index].deviceName, 0);
                              } else {
                                toggleDevice(list1[index].deviceName, 255);
                              }
                              },
                          ),
                        ],
                      ),
                    ),
                    Slider(
                      min: 0,
                      max: 255,
                      divisions: 255,
                      value: list1[index].value.toDouble(),
                      onChanged: (newValue) {
                        setState(() {
                          list1[index].value = newValue.toInt();
                        });
                        },
                      onChangeEnd: (newValue) {
                        toggleDevice(list1[index].deviceName, newValue.toInt());
                        },
                    )
                  ],
                );
                },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: list1.length,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemBuilder:(context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Text(
                        list2[index].firebaseField,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      )),
                      IconButton(
                        icon: ImageIcon(
                          AssetImage(list2[index].state? list2[index].onImg : list2[index].offImg),
                          size: 48,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          if (list2[index].state) {
                            toggleDoor(list2[index].firebaseField, false);
                          } else {
                            toggleDoor(list2[index].firebaseField, true);
                          }
                          },
                      ),
                    ],
                  );
                  },
                separatorBuilder: (context, index) {
                  return Divider();
                  },
                itemCount: list2.length,
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    Firestore.instance.collection('home').document('devices').snapshots().listen((data){
      setState(() {
        list1[0].value = data.data['light1'];
        list1[1].value = data.data['light2'];
        list1[2].value = data.data['fan'];
        list2[0].state = data.data['door'];
        for (int i = 0; i < 3; ++i) {
          if(list1[i].value > 0) {
            list1[i].toggleState = true;
          }
          else {
            list1[i].toggleState = false;
          }
        }
      });
    });
  }

  void toggleDevice(String device, int value) async {
    Firestore.instance.collection('home').document('devices').updateData({device: value});
  }

  void toggleDoor(String device, bool value) async {
    var _msgController = TextEditingController();
    if(value){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext cont) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Enter the Password"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _msgController,
                      decoration: InputDecoration(
                        hintText: "Type the password",
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Submit"),
                    onPressed: () async {
                      Navigator.pop(context);
                      bool temp = await CloudFunctions.instance.call(functionName: "checkPassword", parameters: {"pass": _msgController.text});
                      if(temp){
                        setState(() {
                          list2[0].state = true;
                        });
                      }
                      else {
                        Toast.show("Wrong Password", context, duration: Toast.LENGTH_SHORT,  gravity: Toast.BOTTOM);
                      }
                    },
                  )
                ],
              ),
            ),
          );
        }
      );
    }
    else {
      Firestore.instance.collection('home').document('devices').updateData({device: value});
      setState(() {
        list2[0].state = false;
      });
    }
  }
}