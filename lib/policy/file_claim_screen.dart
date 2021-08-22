import 'package:flutter/material.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FileClaimScreen extends StatefulWidget {
  @override
  _FileClaimScreenState createState() => new _FileClaimScreenState();
}

class _FileClaimScreenState extends State<FileClaimScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "FILE CLAIM",
          style: WidgetHelper.textStyle16AcensWhite,
        ),
        backgroundColor: secondaryColor,
        elevation: 0,
      ),
      body: _buildMainContentView(context),
    );
  }

/*personal*/
  static TextEditingController _fullNameController =
      new TextEditingController();
  static TextEditingController _phoneNumberController =
      new TextEditingController();
  static TextEditingController _addressController = new TextEditingController();
  static TextEditingController _occupationController =
      new TextEditingController();
  static TextEditingController _branchController = new TextEditingController();
  static TextEditingController _policyNumberController =
      new TextEditingController();

  static final String _defInsurancePeriodDisplay = "Insurance Period";
  String _selectedInsuranceDatePeriod = _defInsurancePeriodDisplay;

  /*vehicle section*/
  static TextEditingController _vehicleNumberController =
      new TextEditingController();
  static TextEditingController _yearOfMakeController =
      new TextEditingController();
  static TextEditingController _nameOfOwnerController =
      new TextEditingController();
  static TextEditingController _addressOfOwnerController =
      new TextEditingController();

  static int _currentStep = 0;
  static var _focusNode = new FocusNode();

  List<Step> get steps => <Step>[
        new Step(
            title: const Text('Personal Info'),
            isActive: _currentStep >= 0,
            state: StepState.indexed,
            content: _personalUi()),
        new Step(
            title: const Text('Vehicle Info'),
            isActive: _currentStep >= 1,
            state: StepState.indexed,
            content: _vehicleUi()),
        // new Step(
        //     title: const Text('Driver'),
        //     isActive: _currentStep >= 1,
        //     state: StepState.indexed,
        //     content: _driverUi()),
        // new Step(
        //     title: const Text('Insurance'),
        //     isActive: _currentStep >= 2,
        //     state: StepState.indexed,
        //     content: _insuranceUi()),

        // new Step(
        //     title: const Text('Quote'),
        //     isActive: _currentStep >= 4,
        //     state: StepState.complete,
        //     content: _quoteUi())
      ];

  DateTime _selectedLicenseDate = DateTime.now();
  String _selectedLicenseDateDisplay = "License Issued Date";
  DateTime _selectedDateOfBirth = DateTime.now();
  String _selectedDateOfBirthDisplay = "Date of Birth";

  static final String _defInsuranceType = "Select Insurance Type";
  String _insuranceType = _defInsuranceType;
  var _insuranceTypes = [
    _defInsuranceType,
    "Third Party",
    "Third Party, Fire and Theft",
    "Comprehensive"
  ];

  static final String _defVehicleMake = "Select Vehicle Make";
  String _vehicleMake = _defVehicleMake;
  var _vehicleMakes = [_defVehicleMake, "Vitz", "C300", "C500"];

  /*vehicle section*/
  static TextEditingController _numberOfSeatsController =
      new TextEditingController();
  static TextEditingController _cubicCapacityController =
      new TextEditingController();

  var disclaimer =
      "Kindly note that the premium displayed after the computation is dependent on the values you provided and might be amended or rejected should any discrepancy be noticed at the discretion of Provident Insurance Company Limited. Please tick the box below to confirm your acceptance of this disclaimer.";
  var discliamerTerms = false;
  _showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //MARK: show date range picker
  _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _selectedInsuranceDatePeriod =
            DateFormat('yyyy-MM-dd').format(picked.start) +
                " - " +
                DateFormat('yyyy-MM-dd').format(picked.end);
      });
    }
  }

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
        }
        if (dateOfBirth) {
          _selectedDateOfBirth = picked;
          _selectedDateOfBirthDisplay = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

//MARK: personal ui section
  Widget _personalUi() {
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
                              controller: _occupationController,
                              decoration: AppInputDecorator.boxDecorate(
                                  "Enter occupation"),
                            )),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 16.0),
                            child: new TextFormField(
                              autofocus: false,
                              controller: _branchController,
                              decoration: AppInputDecorator.boxDecorate(
                                  "Enter branch name"),
                            )),
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
                              controller: _policyNumberController,
                              decoration: AppInputDecorator.boxDecorate(
                                  "Enter policy number"),
                            )),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 16.0),
                            child: new TextFormField(
                              autofocus: false,
                              controller: _addressController,
                              decoration: AppInputDecorator.boxDecorate(
                                  "Enter address"),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(width: 1.0, color: Colors.grey)),
                            child: TextButton(
                                onPressed: () {
                                  _selectDateRange();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      _selectedInsuranceDatePeriod,
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
                isExpanded: true,
                value: _insuranceType,
                hint: Text('Choose Insurance Type'),
                items: this._insuranceTypes.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    this._insuranceType = value.toString();
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
  Widget _vehicleUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        Container(
          child: DropdownButton(
            isExpanded: true,
            value: _vehicleMake,
            hint: Text('Choose Vehicle Make'),
            items: this._vehicleMakes.map((value) {
              return DropdownMenuItem(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._vehicleMake = value.toString();
              });
            },
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _vehicleNumberController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Enter Vehicle number"),
            keyboardType: TextInputType.text,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _yearOfMakeController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Enter Year of make"),
            keyboardType: TextInputType.number,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _nameOfOwnerController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Enter name of owner"),
            keyboardType: TextInputType.text,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _addressOfOwnerController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Enter address of owner"),
            keyboardType: TextInputType.text,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _addressOfOwnerController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Enter purpose of use"),
            keyboardType: TextInputType.text,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _addressOfOwnerController,
            autofocus: false,
            decoration:
                AppInputDecorator.boxDecorate("Enter number of trailers"),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    ));
  }

  //MARK: quote ui section
  Widget _quoteUi() {
    return Container(
      child: CheckboxListTile(
        title: Text(disclaimer),
        value: discliamerTerms,
        onChanged: (newValue) {
          setState(() {
            discliamerTerms = newValue!;
          });
        },
        controlAffinity:
            ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  Widget _buildMainContentView(context) {
    return new SafeArea(
      child: new Container(
        child: new ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32, top: 32),
              child: Text("Provide the following information to file a claim."),
            ),
            new Stepper(
              steps: steps,
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: () {
                print("STEP " + _currentStep.toString());
                setState(() {
                  if (_currentStep == 0) {
                    var name = _fullNameController.value.text.toString().trim();
                    var number =
                        _phoneNumberController.value.text.toString().trim();
                    var address =
                        _addressController.value.text.toString().trim();
                    var occupation =
                        _occupationController.value.text.toString().trim();
                    var branch = _branchController.value.text.toString().trim();
                    if (!Validator().isValidName(name)) {
                      this._showMessage("Enter a valid name");
                    } else if (!Validator().isValidInput(occupation)) {
                      this._showMessage("Enter occupation");
                    } else if (!Validator().isValidInput(branch)) {
                      this._showMessage("Enter branch");
                    } else if (!Validator().isValidPhoneNumber(number)) {
                      this._showMessage("Enter a valid number");
                    } else if (!Validator().isValidInput(address)) {
                      this._showMessage("Enter a valid address");
                    } else if (_selectedInsuranceDatePeriod ==
                        _defInsurancePeriodDisplay) {
                      this._showMessage("Select Insurance date period");
                    } else {
                      //MARK: continue to next
                      this.increaseStepper();
                    }
                  } else if (_currentStep == 1) {
                    var vehicleNumber =
                        _vehicleNumberController.value.text.toString().trim();
                    var vehicleMake =
                        _yearOfMakeController.value.text.toString().trim();
                    var nameOfOwner =
                        _nameOfOwnerController.value.text.toString().trim();
                    var ownerAddress =
                        _addressOfOwnerController.value.text.toString().trim();
                    if (_vehicleMake == _defVehicleMake) {
                      this._showMessage("Select vehiicle make");
                    } else if (!Validator().isValidInput(vehicleNumber)) {
                      this._showMessage("Enter vehicle number");
                    } else if (!Validator().isValidInput(vehicleMake)) {
                      this._showMessage("Enter vehicle year of make");
                    } else if (!Validator().isValidInput(nameOfOwner)) {
                      this._showMessage("Enter owner's name");
                    } else if (!Validator().isValidInput(ownerAddress)) {
                      this._showMessage("Enter owner's address");
                    } else {
                      //MARK: continue to next
                      this.increaseStepper();
                    }
                  } else if (_currentStep == 2) {
                    var selected =
                        this._insuranceTypes.contains(this._insuranceType);
                    if (_insuranceType == _defInsuranceType || !selected) {
                      this._showMessage("Select insurance type");
                    } else {
                      //MARK: continue to next
                      this.increaseStepper();
                    }
                  } else if (_currentStep == 3) {
                    var numberOfSeats =
                        _numberOfSeatsController.text.toString().trim();
                    var cubicCapacity =
                        _cubicCapacityController.text.toString().trim();
                    if (_vehicleMake == _defVehicleMake) {
                      this._showMessage("Select vehicle make");
                    } else if (!Validator().isValidInput(numberOfSeats)) {
                      this._showMessage("Enter vehicle number of seats");
                    } else if (!Validator().isValidInput(cubicCapacity)) {
                      this._showMessage("Enter vehicle cubic capacity");
                    } else {
                      //MARK: continue to next
                      this.increaseStepper();
                    }
                  } else if (_currentStep == 4) {
                    this._checkAllRecordsAndSubmit();
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

  void increaseStepper() {
    //MARK: continue to next
    if (_currentStep < steps.length - 1) {
      _currentStep = _currentStep + 1;
    } else {
      _currentStep = 0;
    }
  }

  void _checkAllRecordsAndSubmit() {
    _showMessage("Final Stage To Submit");
  }
}
