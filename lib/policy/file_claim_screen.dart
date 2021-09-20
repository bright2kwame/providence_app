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
  static TextEditingController _purposeOfUseController =
      new TextEditingController();
  static TextEditingController _noOfTrailersController =
      new TextEditingController();
  bool _vehicleCarryingGoods = false;
  bool _vehicleSideCarAttached = false;
  static TextEditingController _chasisNumberController =
      new TextEditingController();

//damage section
  static TextEditingController _damageController = new TextEditingController();
  static final String _defInsuranceType = "Select Insurance Product";
  String _insuranceType = _defInsuranceType;
  var _insuranceTypes = [
    _defInsuranceType,
    "Motor Accident",
    "Personal Accident",
    "Fire and Burglary",
    "Fire Allied Perils",
    "Contractors All Risk",
    "Cash In Transit",
    "Assets All Risk",
    "Public Liability",
    "Bankers Indemity",
    "Pant and Machinery",
    "Professional Indemity",
    "Workmen Compensation"
  ];
  bool _vehicleWithRepairer = false;
  static TextEditingController _placeOfAccidentController =
      new TextEditingController();
  static TextEditingController _descriptionOfAccidentController =
      new TextEditingController();
  static TextEditingController _repairerNameController =
      new TextEditingController();
  static TextEditingController _repairerShopNameController =
      new TextEditingController();
  static TextEditingController _repairerPhoneNumberController =
      new TextEditingController();

  DateTime _selectedAccidentDate = DateTime.now();
  static final String _defAccidentDateDisplay = "Accident Date";
  String _selectedAccidentDateDisplay = _defAccidentDateDisplay;

  static final String _defVehicleMake = "Select Vehicle Make";
  String _vehicleMake = _defVehicleMake;
  var _vehicleMakes = [_defVehicleMake, "Vitz", "C300", "C500"];

  static int _currentStep = 0;
  static var _focusNode = new FocusNode();

  List<Step> get steps => <Step>[
        new Step(
            title: const Text('Personal Info'),
            isActive: _currentStep >= 0,
            state: StepState.indexed,
            content: _personalUi()),
        new Step(
            title: const Text('Vehicle Info 1'),
            isActive: _currentStep >= 1,
            state: StepState.indexed,
            content: _vehicleUi()),
        new Step(
            title: const Text('Vehicle Info 2'),
            isActive: _currentStep >= 2,
            state: StepState.indexed,
            content: _vehicleTwoUi()),
        new Step(
            title: const Text('Damage Info 1'),
            isActive: _currentStep >= 3,
            state: StepState.indexed,
            content: _damageUi()),
        new Step(
            title: const Text('Damage Info 2'),
            isActive: _currentStep >= 4,
            state: StepState.indexed,
            content: _damageTwoUi()),
        new Step(
            title: const Text('Damage Info 3'),
            isActive: _currentStep >= 5,
            state: StepState.indexed,
            content: _damageThreeUi()),
        new Step(
            title: const Text('Documents'),
            isActive: _currentStep >= 6,
            state: StepState.indexed,
            content: _documentUi()),
        new Step(
            title: const Text('Confirm'),
            isActive: _currentStep >= 7,
            state: StepState.complete,
            content: _confirmUi()),
      ];

  bool _ownDamageReport = false;
  bool _isInjuryReport = false;
  bool _isDeathReport = false;

  var disclaimer =
      "Kindly note that the premium displayed after the computation is dependent on the values you provided and might be amended or rejected should any discrepancy be noticed at the discretion of Provident Insurance Company Limited. Please tick the box below to confirm your acceptance of this disclaimer.";
  var discliamerTerms = false;
  void _showMessage(String message) {
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
  void _selectDateRange() async {
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
  void _selectDate(bool isAccidentDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (isAccidentDate) {
          _selectedAccidentDate = picked;
          this._selectedAccidentDateDisplay =
              DateFormat('yyyy-MM-dd').format(picked);
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

  //MARK: damage ui section
  Widget _damageUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16, bottom: 8),
          child: new TextFormField(
            controller: _damageController,
            autofocus: false,
            minLines: 2,
            maxLines: 3,
            decoration:
                AppInputDecorator.boxDecorate("Explain Damage to vehicle"),
            keyboardType: TextInputType.text,
          ),
        ),
        Container(
          child: DropdownButton(
            isExpanded: true,
            value: _insuranceType,
            hint: Text('Choose Insurance Product'),
            items: this._insuranceTypes.map((value) {
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
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16, bottom: 0),
          child: new TextFormField(
            controller: _placeOfAccidentController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Place of accident"),
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1.0, color: Colors.grey)),
            child: TextButton(
                onPressed: () {
                  _selectDate(true);
                },
                child: Row(
                  children: [
                    Text(
                      _selectedAccidentDateDisplay,
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
        )
      ],
    ));
  }

  //MARK: damage ui section
  Widget _damageTwoUi() {
    return Container(
        child: new Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8, bottom: 8),
          child: new TextFormField(
            controller: _descriptionOfAccidentController,
            autofocus: false,
            minLines: 2,
            maxLines: 3,
            decoration:
                AppInputDecorator.boxDecorate("Description of Accident"),
            keyboardType: TextInputType.text,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
          child: CheckboxListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text("Is the vehicle at repairer’s premises?"),
            value: _vehicleWithRepairer,
            onChanged: (newValue) {
              setState(() {
                _vehicleWithRepairer = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16, bottom: 0),
          child: new TextFormField(
            controller: _repairerNameController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Repairer's name"),
            keyboardType: TextInputType.text,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16, bottom: 0),
          child: new TextFormField(
            controller: _repairerShopNameController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Repairer's shop name"),
            keyboardType: TextInputType.name,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16, bottom: 0),
          child: new TextFormField(
            controller: _repairerPhoneNumberController,
            autofocus: false,
            decoration:
                AppInputDecorator.boxDecorate("Repairer's phone number"),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    ));
  }

//MARK: damage ui section
  Widget _damageThreeUi() {
    return Column(children: [
      new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
        child: CheckboxListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text("Own Damage Claim?"),
          value: _ownDamageReport,
          onChanged: (newValue) {
            setState(() {
              _ownDamageReport = newValue!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
      new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
        child: CheckboxListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text("Injury  ?"),
          value: _isInjuryReport,
          onChanged: (newValue) {
            setState(() {
              _isInjuryReport = newValue!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
      new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
        child: CheckboxListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text("Death ?"),
          value: _isDeathReport,
          onChanged: (newValue) {
            setState(() {
              _isDeathReport = newValue!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    ]);
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
      ],
    ));
  }

  Widget _vehicleTwoUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _purposeOfUseController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Enter purpose of use"),
            keyboardType: TextInputType.text,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _noOfTrailersController,
            autofocus: false,
            decoration:
                AppInputDecorator.boxDecorate("Enter number of trailers"),
            keyboardType: TextInputType.text,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Were goods being carried?"),
            value: _vehicleCarryingGoods,
            onChanged: (newValue) {
              setState(() {
                _vehicleCarryingGoods = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Was a Side Car Attached?"),
            value: _vehicleSideCarAttached,
            onChanged: (newValue) {
              setState(() {
                _vehicleSideCarAttached = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _chasisNumberController,
            autofocus: false,
            decoration:
                AppInputDecorator.boxDecorate("Enter vehicle chasis number"),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    ));
  }

  //MARK: document ui section
  Widget _documentUi() {
    return Column(children: [
      new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
        child: Text("PLEASE UPLOAD THE FF. DOCUMENTS BELOW Eg. Police Report"),
      ),
      GestureDetector(
        onTap: () {},
        child: new Container(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
          decoration: BoxDecoration(
              border: Border.all(color: secondaryColor.withAlpha(50), width: 5),
              shape: BoxShape.rectangle,
              color: Colors.grey.withAlpha(100)),
          child: Column(
            children: [
              Icon(
                Icons.file_copy_outlined,
                size: 40,
                color: Colors.grey,
              ),
              Text(
                "Click to upload document here",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
      new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
        child: Text(
          "Click inside the box above to upload all the specified documents one after the other. You can also upload all at once by dragging and dropping into the box",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
    ]);
  }

  //MARK: confirm ui section
  Widget _confirmUi() {
    return Container(
      child: CheckboxListTile(
        title: Text(disclaimer),
        value: discliamerTerms,
        onChanged: (newValue) {
          setState(() {
            discliamerTerms = newValue!;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
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
                  this.handleStepClicks();
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

  void handleStepClicks() {
    if (_currentStep == 0) {
      var name = _fullNameController.value.text.toString().trim();
      var number = _phoneNumberController.value.text.toString().trim();
      var address = _addressController.value.text.toString().trim();
      var occupation = _occupationController.value.text.toString().trim();
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
      } else if (_selectedInsuranceDatePeriod == _defInsurancePeriodDisplay) {
        this._showMessage("Select Insurance date period");
      } else {
        //MARK: continue to next
        this.increaseStepper();
      }
    } else if (_currentStep == 1) {
      var vehicleNumber = _vehicleNumberController.value.text.toString().trim();
      var vehicleMake = _yearOfMakeController.value.text.toString().trim();
      var nameOfOwner = _nameOfOwnerController.value.text.toString().trim();
      var ownerAddress = _addressOfOwnerController.value.text.toString().trim();

      if (_vehicleMake == _defVehicleMake) {
        this._showMessage("Select vehicle make");
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
      var purpose = _purposeOfUseController.value.text.toString().trim();
      var noOfTrailers = _noOfTrailersController.value.text.toString().trim();
      var chasisNumber = _chasisNumberController.value.text.toString().trim();
      if (!Validator().isValidInput(purpose)) {
        this._showMessage("Enter purpose of use");
      } else if (!Validator().isValidInput(noOfTrailers)) {
        this._showMessage("Enter number of trailers");
      } else if (!Validator().isValidInput(chasisNumber)) {
        this._showMessage("Enter chasis number");
      } else {
        //MARK: continue to next
        this.increaseStepper();
      }
    } else if (_currentStep == 3) {
      var damageExplanation = _damageController.value.text.toString().trim();
      var placeOfAccident =
          _placeOfAccidentController.value.text.toString().trim();

      if (!Validator().isValidInput(damageExplanation)) {
        this._showMessage("Explain the damage caused");
      } else if (_insuranceType == _defInsuranceType) {
        this._showMessage("Select the insurance type");
      } else if (!Validator().isValidInput(placeOfAccident)) {
        this._showMessage("State the accident place");
      } else if (_selectedAccidentDateDisplay == _defAccidentDateDisplay) {
        this._showMessage("State the accident date");
      } else {
        //MARK: continue to next
        this.increaseStepper();
      }
    } else if (_currentStep == 4) {
      var accidentDescription =
          _descriptionOfAccidentController.text.toString().trim();
      var repairerName = _repairerNameController.text.toString().trim();
      var repairerShopName = _repairerShopNameController.text.toString().trim();
      var repairerPhone = _repairerPhoneNumberController.text.toString().trim();
      if (!Validator().isValidInput(accidentDescription)) {
        this._showMessage("Enter accident description");
      } else if (_vehicleWithRepairer &&
          !Validator().isValidInput(repairerName)) {
        this._showMessage("Enter repairer's name");
      } else if (_vehicleWithRepairer &&
          !Validator().isValidInput(repairerShopName)) {
        this._showMessage("Enter repairer's shop name");
      } else if (_vehicleWithRepairer &&
          !Validator().isValidInput(repairerPhone)) {
        this._showMessage("Enter repairer's phone number");
      } else {
        //MARK: continue to next
        this.increaseStepper();
      }
    } else if (_currentStep == 5) {
      this.increaseStepper();
    } else if (_currentStep == 6) {
      this._checkAllRecordsAndSubmit();
    }
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
