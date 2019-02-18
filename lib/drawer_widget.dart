import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {

  var list = [['Home', '/home'], ['Devices', '/devices']];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index][0]),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, list[index][1]);
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