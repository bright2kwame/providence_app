import 'package:flutter/material.dart';
import 'package:provident_insurance/onboarding/password_login_screen.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  TextEditingController _numberController = new TextEditingController();
  var _isLoading = false;
  FocusNode _focusNumber = new FocusNode();
  String _phoneNumber = "";

  //MAKE: api call here
  void startApiCall() {
    setState(() {
      this._isLoading = true;
    });

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            new PasswordLoginScreen(this._phoneNumber)));
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
        body: _buildMainContentView(context),
      ),
    );
  }

  //MARK: show dialog to confirm number inputted
  void _startCheck() {
    this._phoneNumber = this._numberController.text;
    if (this._phoneNumber.isEmpty) {
      return;
    }

    this.startApiCall();
  }

  //MARK: take user to terms page
  void _openTermsPage() {}

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
                      fontSize: 40.0,
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
                  this._startCheck();
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
