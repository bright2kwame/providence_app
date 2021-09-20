import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/onboarding/password_login_screen.dart';
import 'package:provident_insurance/onboarding/register_screen.dart';
import 'package:provident_insurance/onboarding/verification_screen.dart';
import 'package:provident_insurance/util/pop_up_helper.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  TextEditingController _numberController = new TextEditingController();
  FocusNode _focusNumber = new FocusNode();
  String _phoneNumber = "";

  //MAKE: api call here
  void startApiCall(BuildContext context) {
    final progress = ProgressHUD.of(context);
    Map<String, String> data = new Map();
    if (_phoneNumber.startsWith("0")) {
      _phoneNumber = _phoneNumber.replaceRange(0, 0, "");
    }
    this._phoneNumber = "+233" + _phoneNumber;
    data.putIfAbsent("phone_number", () => _phoneNumber);
    progress?.show();
    ApiService().postDataNoHeader(ApiUrl().checkPhone(), data).then((value) {
      print(value);
      String responseCode = value["response_code"];
      if (responseCode == "100") {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new PasswordLoginScreen(this._phoneNumber)));
      } else if (responseCode == "101") {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new VerificationScreen(this._phoneNumber)));
      } else if (responseCode == "102") {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new RegisterScreen(this._phoneNumber)));
      } else {
        String detail = value["detail"];
        PopUpHelper(context, "Login Failed", detail).showMessageDialog("OK");
      }
    }).whenComplete(() {
      progress?.dismiss();
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Login Failed", error.toString())
          .showMessageDialog("OK");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: new AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: BackButton(color: secondaryColor)),
        body: ProgressHUD(
            child: Builder(
          builder: (context) => _buildMainContentView(context),
        )),
      ),
    );
  }

  //MARK: show dialog to confirm number inputted
  void _startCheck(BuildContext context) {
    this._phoneNumber = this._numberController.text;
    if (this._phoneNumber.isEmpty) {
      return;
    }

    this.startApiCall(context);
  }

  //MARK: take user to terms page
  void _openTermsPage() async {
    const url = 'https://www.providentgh.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildMainContentView(context) {
    return new SafeArea(
        child: new Container(
      child: new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Center(
              child: Container(
                  padding: EdgeInsets.all(16),
                  child: new Image(
                    image: AssetImage(ImageResource.appLogoSmall),
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  )),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Getting Started",
                  style: new TextStyle(
                      fontSize: 32.0,
                      fontFamily: TextConstant.roboto,
                      color: secondaryColor),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusNumber.unfocus();
                },
                validator: (val) => Validator().validateMobile(val!),
                onSaved: (val) => this._phoneNumber = val!,
                controller: this._numberController,
                decoration: AppInputDecorator.boxDecorate("Enter phone number"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 64, left: 32, right: 32),
              child: TextButton(
                style: WidgetHelper.raisedButtonStyle,
                onPressed: () {
                  this._startCheck(context);
                },
                child: Text('Get Started'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 32, right: 32),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    primary: secondaryColor,
                    onSurface: secondaryColor),
                onPressed: () {
                  this._openTermsPage();
                },
                child: Text(
                  'Terms and Conditions',
                  style: WidgetHelper.textStyle12Colored,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
