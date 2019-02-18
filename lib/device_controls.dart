import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'device_data.dart';
import 'drawer_widget.dart';

class DeviceControls extends StatefulWidget {

  @override
  _DeviceControls createState() => _DeviceControls();
}

class _DeviceControls extends State<DeviceControls> {

  var list = [DeviceData('light', false, 0, Icons.lightbulb_outline), DeviceData('fan', false, 0, Icons.lightbulb_outline)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controlls"),
      ),
      drawer: Drawer(
        child: DrawerWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
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
                      Expanded(child: Text(list[index].deviceName)),
                      IconButton(
                        icon: Icon(
                          list[index].iconData,
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
      ),
    );
  }

  void toggleDevice(String device, int value) async {
    Firestore.instance.collection('home').document('devices').updateData({device: value});
  }
}