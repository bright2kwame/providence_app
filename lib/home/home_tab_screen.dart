import 'package:flutter/material.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'drawer_menu_screen.dart';
import 'profile_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class HomeTabScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeTabScreenState();
  }
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  int _currentIndex = 1;
  String _displayTitle = "DASHBOARD";
  final List<Widget> _children = [ProfilePage(), HomePage(), SettingsPage()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        _displayTitle = "DASHBOARD";
      } else if (index == 0) {
        _displayTitle = "PROFILE";
      } else {
        _displayTitle = "SETTINGS";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._displayTitle,
          style: WidgetHelper.textStyle16AcensWhite,
        ),
        backgroundColor: secondaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      // drawer: Container(
      //     width: MediaQuery.of(context).size.width * 0.75,
      //     child: Drawer(child: DrawerMenuPage())),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedFontSize: 20,
        unselectedItemColor: Colors.black,
        unselectedIconTheme: IconThemeData(color: Colors.black, size: 30),
        selectedIconTheme: IconThemeData(color: Colors.white, size: 30),
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: secondaryColor,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.other_houses_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          )
        ],
      ),
    );
  }
}
