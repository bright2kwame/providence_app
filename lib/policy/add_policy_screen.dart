import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import '../constants/image_resource.dart';
import 'package:intl/intl.dart';

class AddPolicyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPolicyScreenState();
  }
}

class _AddPolicyScreenState extends State<AddPolicyScreen> {
  /*personal*/
  static TextEditingController _fullNameController =
      new TextEditingController();
  static TextEditingController _phoneNumberController =
      new TextEditingController();
  static TextEditingController _emailAddressController =
      new TextEditingController();

  /*driver section*/
  static TextEditingController _yearsOfContinousDrivingController =
      new TextEditingController();

  static int _currentStep = 0;
  static var _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<Step> steps = [
    new Step(
        title: const Text('Personal'),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
        content: _personalUi()),
    new Step(
        title: const Text('Vehicle'),
        isActive: _currentStep >= 3,
        state: StepState.indexed,
        content: _vehicleUi()),
    new Step(
        title: const Text('Quote'),
        isActive: _currentStep >= 4,
        state: StepState.complete,
        content: _quoteUi()),
  ];

  DateTime _selectedLicenseDate = DateTime.now();
  String _selectedLicenseDateDisplay = "License Issued Date";
  DateTime _selectedDateOfBirth = DateTime.now();
  String _selectedDateOfBirthDisplay = "Date of Birth";
  String _insuranceType = "Select Insurance Type";
  var _insuranceTypes = [
    "Third Party",
    "Third Party, Fire and Theft",
    "Comprehensive"
  ];

//MARK: show date picker
  _selectDate(bool isLicenseIssuedDate, bool dateOfBirth) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (isLicenseIssuedDate) {
          _selectedLicenseDate = picked;
          this._selectedLicenseDateDisplay =
              DateFormat('yyyy-MM-dd').format(picked);
          print("PASS IN $_selectedLicenseDateDisplay");
        }
        if (dateOfBirth) {
          _selectedDateOfBirth = picked;
          _selectedDateOfBirthDisplay = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

//MARK: personal ui section
  static Widget _personalUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
                child: new Center(
              child: new Stack(
                children: <Widget>[
                  new Form(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                          child: new TextFormField(
                            controller: _fullNameController,
                            autofocus: false,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter full name"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 16.0),
                            child: new TextFormField(
                              autofocus: false,
                              controller: _phoneNumberController,
                              decoration: AppInputDecorator.boxDecorate(
                                  "Enter phone number"),
                            )),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 16.0),
                            child: new TextFormField(
                              autofocus: false,
                              controller: _emailAddressController,
                              decoration: AppInputDecorator.boxDecorate(
                                  "Enter email address"),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        )
      ],
    ));
  }

  //MARK: driver ui section
  Widget _driverUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Stack(
              children: <Widget>[
                new Form(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(width: 1.0, color: Colors.grey)),
                          child: TextButton(
                              onPressed: () {
                                this._selectDate(true, false);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    this._selectedLicenseDateDisplay,
                                    textAlign: TextAlign.left,
                                  ),
                                  Expanded(child: Container()),
                                  Icon(
                                    Icons.date_range_outlined,
                                    size: 20,
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(width: 1.0, color: Colors.grey)),
                          child: TextButton(
                              onPressed: () {
                                this._selectDate(false, true);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    _selectedDateOfBirthDisplay,
                                    textAlign: TextAlign.left,
                                  ),
                                  Expanded(child: Container()),
                                  Icon(
                                    Icons.date_range_outlined,
                                    size: 20,
                                  ),
                                ],
                              )),
                        ),
                      ),
                      new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 32.0),
                          child: new TextFormField(
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            controller: _yearsOfContinousDrivingController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Years of driving"),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    ));
  }

  //MARK: insurance ui section
  Widget _insuranceUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        new Stack(
          children: <Widget>[
            Container(
              child: DropdownButton<String>(
                //value: _insuranceType,
                hint: Text('Choose Insurance Type'),
                items: this._insuranceTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    this._insuranceType = value!;
                  });
                },
              ),
            )
          ],
        ),
      ],
    ));
  }

  //MARK: vehicle ui section
  static Widget _vehicleUi() {
    return Container();
  }

  //MARK: quote ui section
  static Widget _quoteUi() {
    return Container();
  }

  @override
  void initState() {
    super.initState();

    var driverStepper = new Step(
        title: const Text('Driver'),
        isActive: _currentStep >= 1,
        state: StepState.indexed,
        content: _driverUi());
    steps.insert(1, driverStepper);

    var insuranceStepper = new Step(
        title: const Text('Insurance'),
        isActive: _currentStep >= 2,
        state: StepState.indexed,
        content: _insuranceUi());
    steps.insert(2, insuranceStepper);

    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GET QUOTE",
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
        child: new ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32, top: 32),
              child: Text("Provide the following information to get a quote."),
            ),
            new Stepper(
              steps: steps,
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: () {
                setState(() {
                  if (_currentStep == 0) {
                    if (_fullNameController.value.text
                        .toString()
                        .trim()
                        .isEmpty) {
                    } else if (_phoneNumberController.value.text
                        .toString()
                        .trim()
                        .isEmpty) {
                    } else if (_emailAddressController.value.text
                        .toString()
                        .trim()
                        .isEmpty) {
                    } else {
                      //MARK: continue to next
                      if (_currentStep < steps.length - 1) {
                        _currentStep = _currentStep + 1;
                      } else {
                        _currentStep = 0;
                      }
                    }
                  } else if (_currentStep == 1) {
                    if (_selectedDateOfBirthDisplay.isEmpty) {
                    } else if (_selectedLicenseDateDisplay.isEmpty) {
                    } else if (_yearsOfContinousDrivingController.value.text
                        .toString()
                        .trim()
                        .isEmpty) {
                    } else {
                      //MARK: continue to next
                      if (_currentStep < steps.length - 1) {
                        _currentStep = _currentStep + 1;
                      } else {
                        _currentStep = 0;
                      }
                    }
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (_currentStep > 0) {
                    _currentStep = _currentStep - 1;
                  } else {
                    _currentStep = 0;
                  }
                });
              },
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
            ),
          ],
          shrinkWrap: true,
          reverse: false,
        ),
      ),
    );
  }
}
