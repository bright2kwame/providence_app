import 'package:flutter/material.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import '../constants/image_resource.dart';

class AddPolicyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPolicyScreenState();
  }
}

class _AddPolicyScreenState extends State<AddPolicyScreen> {
  TextEditingController _vehicleNumberController = new TextEditingController();
  TextEditingController _nameOfPolicyController = new TextEditingController();
  var _isLoading = false;
  FocusNode _focusVehicleNumber = new FocusNode();
  FocusNode _focusNameOnPolicy = new FocusNode();
  String _vehicleNumber = "";
  String _nameOnPolicy = "";

  void _startCheck() {
    this._vehicleNumber = this._vehicleNumberController.text.trim();
    this._nameOnPolicy = this._nameOfPolicyController.text.trim();

    if (this._nameOnPolicy.isEmpty || this._vehicleNumber.isEmpty) {
      print("Nothing");
    }

    setState(() {
      this._isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ADD POLICY",
          style: WidgetHelper.textStyle16AcensWhite,
        ),
        backgroundColor: secondaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildMainContentView(context),
    );
  }

  Widget _buildMainContentView(context) {
    return new SafeArea(
        child: new Container(
      child: new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(32)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusVehicleNumber.unfocus();
                },
                validator: (val) => Validator().validateName(val!),
                onSaved: (val) => this._vehicleNumber = val!,
                controller: this._vehicleNumberController,
                decoration:
                    AppInputDecorator.boxDecorate("Enter vehicle number"),
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
                  _focusNameOnPolicy.unfocus();
                },
                validator: (val) => Validator().validateName(val!),
                onSaved: (val) => this._nameOnPolicy = val!,
                controller: this._nameOfPolicyController,
                decoration:
                    AppInputDecorator.boxDecorate("Enter name on policy"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 64, left: 32, right: 32),
              child: TextButton(
                style: WidgetHelper.raisedButtonStyle,
                onPressed: () {
                  this._startCheck();
                },
                child: Text('Validate Policy'),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
