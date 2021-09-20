import 'package:flutter/material.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/onboarding/register_screen.dart';
import 'package:provident_insurance/util/pop_up_helper.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter/services.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  VerificationScreen(this.phoneNumber);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<VerificationScreen>
    with TickerProviderStateMixin {
  TextEditingController _codeController = new TextEditingController();
  FocusNode _focusCode = new FocusNode();
  String _code = "";

  //MAKE: api call here
  void startApiCall(BuildContext context) {
    Map<String, String> data = new Map();
    data.putIfAbsent("phone_number", () => widget.phoneNumber);
    data.putIfAbsent("unique_code", () => this._code);
    final progress = ProgressHUD.of(context);
    progress?.show();
    ApiService()
        .postDataNoHeader(ApiUrl().verifyPhoneumber(), data)
        .then((value) {
      String responseCode = value["response_code"];
      if (responseCode != "100") {
        PopUpHelper(context, "Verification Error", value["detail"])
            .showMessageDialog("OK");
      } else {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new RegisterScreen(widget.phoneNumber)));
      }
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Verification Failed", error.toString())
          .showMessageDialog("OK");
    }).whenComplete(() {
      progress?.dismiss();
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

  //MARK: start the verification process
  void _startCheck(BuildContext context) {
    this._code = this._codeController.text.trim();
    if (this._code.length != 6) {
      PopUpHelper(context, "Required Field",
              "Provide a valid 6 Digit verification code")
          .showMessageDialog("OK");
      return;
    }
    this.startApiCall(context);
  }

  //MARK: resend the verification
  void _resendCode(BuildContext context) {
    Map<String, String> data = new Map();
    data.putIfAbsent("phone_number", () => widget.phoneNumber);
    final progress = ProgressHUD.of(context);
    progress?.show();
    ApiService()
        .postDataNoHeader(ApiUrl().resendVerificationCode(), data)
        .then((value) {
      PopUpHelper(context, "Code Sent", "Verification code sent")
          .showMessageDialog("OK");
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Resend Code", error.toString())
          .showMessageDialog("OK");
    }).whenComplete(() {
      progress?.dismiss();
    });
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
                      fontSize: 30.0,
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
                  style: WidgetHelper.textStyle12,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                maxLength: 6,
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
                  this._resendCode(context);
                },
                child: Text('Resend Verification Code'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 64, left: 32, right: 32),
              child: TextButton(
                style: WidgetHelper.raisedButtonStyle,
                onPressed: () {
                  this._startCheck(context);
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
