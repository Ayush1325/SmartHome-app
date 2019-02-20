import 'package:flutter/material.dart';
import 'monitor_page.dart';
import 'device_controls.dart';
import 'drawer_widget.dart';


class Controller extends StatefulWidget {

  @override
  _Controller createState() => _Controller();
}

class _Controller extends State<Controller> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Controls'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Devices',),
              Tab(text: 'Monitor',)
            ],
          ),
        ),
        drawer: Drawer(
          child: DrawerWidget(),
        ),
        body: TabBarView(
          children: [
            DeviceControls(),
            MonitorPage(),
          ],
        ),
      ),
    );
  }
}