import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'device_data.dart';
import 'door_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeviceControls extends StatefulWidget {

  @override
  _DeviceControls createState() => _DeviceControls();
}

class _DeviceControls extends State<DeviceControls> {

  var list = [DeviceData('light1', false, 0, 'images/light-bulb.png'), DeviceData('light2', false, 0, 'images/light-bulb.png'), DeviceData('fan', false, 0, 'images/fan.png')];
  var list2 = [Door("Door", "door", false, "images/door_open.png", "images/door_closed.png")];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ListView.separated(
              itemCount: list.length,
              separatorBuilder: (context, index) {
                return Divider(
                );
              },
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
                            list[index].deviceName,
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          )),
                          IconButton(
                            icon: ImageIcon(
                              AssetImage(list[index].iconData),
                              size: 48,
                              color: list[index].toggleState? Colors.amberAccent : Colors.black,
                            ),
                            onPressed: () {
                              if(list[index].toggleState){
                                toggleDevice(list[index].deviceName, 0);
                                setState(() {
                                  list[index].toggleState = false;
                                  list[index].value = 0;
                                });
                              } else {
                                toggleDevice(list[index].deviceName, 255);
                                setState(() {
                                  list[index].toggleState = true;
                                  list[index].value = 255;
                                });
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
                      value: list[index].value,
                      onChanged: (newValue) {
                        setState(() {
                          list[index].value = newValue;
                          if(newValue > 0) {
                            list[index].toggleState = true;
                          }else {
                            list[index].toggleState = false;
                          }
                        });
                      },
                    onChangeEnd: (newValue) {
                        toggleDevice(list[index].deviceName, newValue.toInt());
                    },
                    )
                  ],
                );
              },
            ),
            ListView.separated(
              itemBuilder:(context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Text(
                      list2[index].name,
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
                          toggleDoor(list2[index].name, false);
                        } else {
                          toggleDoor(list2[index].name, true);
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
          ],
        ),
    );
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
          return Column(
            children: <Widget>[
              Text("Enter the Password"),
              TextField(
                controller: _msgController,
                decoration: InputDecoration(
                  hintText: "Type the password",
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  bool temp = await CloudFunctions.instance.call(functionName: "checkPassword", parameters: {"pass": _msgController.value});
                  if(temp){
                    Firestore.instance.collection('home').document('devices').updateData({device: value});
                    setState(() {
                      list2[0].state = true;
                    });
                  }
                  else {
                    Fluttertoast.showToast(
                        msg: "Wrong Password",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                },
              )
            ],
          );
        }
      );
    }
    else {
      Firestore.instance.collection('home').document('devices').updateData({device: value});
    }
  }
}