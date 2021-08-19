import 'package:flutter/material.dart';
import 'package:provident_insurance/onboarding/password_login_screen.dart';
import 'package:provident_insurance/onboarding/register_screen.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  VerificationScreen(this.phoneNumber);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<VerificationScreen>
    with TickerProviderStateMixin {
  TextEditingController _codeController = new TextEditingController();
  var _isLoading = false;
  FocusNode _focusCode = new FocusNode();
  String _code = "";

  //MAKE: api call here
  void startApiCall() {
    setState(() {
      this._isLoading = true;
    });

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            new RegisterScreen(widget.phoneNumber)));
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
    this._code = this._codeController.text;
    if (this._code.length != 4) {
      print("No number available");
      return;
    }
    this.startApiCall();
  }

  //MARK: take user to terms page
  void _resendCode() {
    
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
                  "Verification",
                  style: new TextStyle(
                      fontSize: 40.0,
                      fontFamily: TextConstant.roboto,
                      color: secondaryColor),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "A verification code has been sent to: " + widget.phoneNumber,
                  style: WidgetHelper.textStyle16Black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusCode.unfocus();
                },
                validator: (val) => Validator().validateCode(val!),
                onSaved: (val) => this._code = val!,
                controller: this._codeController,
                decoration:
                    AppInputDecorator.boxDecorate("Enter verification code"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0, left: 32, right: 32),
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: secondaryColor, onSurface: secondaryColor),
                onPressed: () {
                  this._resendCode();
                },
                child: Text('Resend Verification Code'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 64, left: 32, right: 32),
              child: TextButton(
                style: WidgetHelper.raisedButtonStyle,
                onPressed: () {
                  this._startCheck();
                },
                child: Text('Verify Number'),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
