import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../constants/image_resource.dart';
import 'package:provident_insurance/onboarding/login_screen.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //MARK: going to the next page
  void _navigateNext() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 32, right: 32, top: 64),
              child: new Image(
                image: AssetImage(ImageResource.appLogo),
                fit: BoxFit.contain,
                width: 200,
                height: 100,
              )),
          Expanded(
            child: Container(),
          ),
          Row(
            children: [
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.all(32),
                child: Container(
                  width: 100,
                  height: 100,
                  padding: EdgeInsets.all(8),
                  child: FloatingActionButton(
                    onPressed: _navigateNext,
                    backgroundColor: primaryColor,
                    child: Icon(Icons.arrow_forward),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withAlpha(50)),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
