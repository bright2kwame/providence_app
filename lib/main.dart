import 'package:flutter/material.dart';
import 'package:provident_insurance/onboarding/splash_screen.dart';
import 'model/all_model_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  // final bool isInitialized = await myDbModel().initializeDB();
  // if (isInitialized == true) {
  //   runApp(MyApp());
  // } else {
  //   // If the database is not initialized, something went wrong.
  //   // Check DEBUG CONSOLE for alerts
  // }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provident Insurance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
