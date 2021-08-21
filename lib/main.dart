import 'package:flutter/material.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/home/home_tab_screen.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/onboarding/splash_screen.dart';
import 'model/db_operations.dart';

String HOME_SCREEN = '/HomeScreen', SPLASH_SCREEN = '/SplashScreen';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var users = await DBOperations().users();
  runApp(MyApp(users.isNotEmpty));
}

class MyApp extends StatelessWidget {
  MyApp(this.isLoggedIn);
  final bool isLoggedIn;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provident Insurance',
      theme: ThemeData(primarySwatch: Colors.blue, accentColor: primaryColor),
      debugShowCheckedModeBanner: false,
      home: this.isLoggedIn ? HomeTabScreen() : SplashPage(),
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => new SplashPage(),
        HOME_SCREEN: (BuildContext context) => new HomeTabScreen(),
      },
    );
  }
}
