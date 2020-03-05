import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';

///
/// Application drawer
///
class AppDrawer extends StatelessWidget {
  AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authServiceProvider = Provider.of<AuthService>(context);

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100,
            color: Colors.grey[300],
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    FontAwesomeIcons.cogs,
                    color: Colors.grey[700],
                    size: 60,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Preferences",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.black,
                size: 30.0,
              ),
              title: Text(
                "Settings",
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              onTap: () {}
          ),
          Divider(
            height: 1,
            thickness: 1
          ),
          ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.black,
                size: 30.0,
              ),
              title: Text(
                "About",
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              onTap: () {}
          ),
          Divider(
            height: 1,
            thickness: 1
          ),
          ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black,
                size: 30.0,
              ),
              title: Text(
                "Log out",
                style: TextStyle(
                  fontSize: 18
                ),
              ),
              onTap: () => authServiceProvider.signOut(),
          ),
        ],
      ),
    );
  }
}
