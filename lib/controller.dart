import 'package:flutter/material.dart';
import 'monitor_page.dart';
import 'device_controls.dart';
import 'drawer_widget.dart';
import 'firebase_helper.dart';
import 'system_calls.dart';


class Controller extends StatefulWidget {

  final FirebaseHelper firebaseHelper;
  Controller({Key key, this.firebaseHelper});
  @override
  _Controller createState() => _Controller();
}

class _Controller extends State<Controller> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Controls'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Devices',),
              Tab(text: 'Monitor',),
              Tab(text: 'System Calls',)
            ],
          ),
        ),
        drawer: Drawer(
          child: DrawerWidget(firebaseHelper: widget.firebaseHelper,),
        ),
        body: TabBarView(
          children: [
            DeviceControls(),
            MonitorPage(),
            SystemCalls(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.firebaseHelper.context = context;
  }


}