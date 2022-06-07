import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/constants/app_enums.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/util/pop_up_helper.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';

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
      body: ProgressHUD(
          child: Builder(
        builder: (context) => _buildMainContentView(context),
      )),
    );
  }

  File? licenseFrontFile;
  File? licenseBackFile;
  File? damagedVehicleFile;
  File? otherDamagedVehicleFile;
  File? otherPropertyFile;
  File? estimateFile;
  File? claimFile;

  /*vehicle section*/
  static TextEditingController _vehicleNumberController =
      new TextEditingController();
  static TextEditingController _nameOfDriverController =
      new TextEditingController();
  static TextEditingController _addressOfDriverController =
      new TextEditingController();
  static TextEditingController _phoneOfDriverController =
      new TextEditingController();
  static TextEditingController _passengerDetailsController =
      new TextEditingController();
  static TextEditingController _otherDriversInsuranceCompanyController =
      new TextEditingController();
  static TextEditingController _otherPartiesDetailController =
      new TextEditingController();
  static TextEditingController _injuredPersonDetailController =
      new TextEditingController();
  static TextEditingController _damageCausedToOtherDetailController =
      new TextEditingController();
  static TextEditingController _policeStationDetailController =
      new TextEditingController();
  static TextEditingController _descriptionOfAccidentController =
      new TextEditingController();
  static TextEditingController _addressOfDamagedVehicleController =
      new TextEditingController();

//damage section
  static TextEditingController _damageController = new TextEditingController();
  static TextEditingController _placeOfAccidentController =
      new TextEditingController();

  static final String _defAccidentDateDisplay = "Accident Date";
  String _selectedAccidentDateDisplay = _defAccidentDateDisplay;

  static final String _defAccidentTimeDisplay = "Time of Accident";
  String _selectedAccidentTimeDisplay = _defAccidentTimeDisplay;

  static int _currentStep = 0;
  static var _focusNode = new FocusNode();

  List<Step> get steps => <Step>[
        new Step(
            title: const Text('Accident Detail'),
            isActive: _currentStep >= 0,
            state: StepState.indexed,
            content: _personalUi()),
        new Step(
            title: const Text(
                'Select The Options Below If Your Answer To The Questions Is Yes'),
            isActive: _currentStep >= 1,
            state: StepState.indexed,
            content: _checkActionsUi()),
        new Step(
            title: const Text('Drivers\' Information'),
            isActive: _currentStep >= 2,
            state: StepState.indexed,
            content: _driverInfoUi()),
        new Step(
            title: const Text('Documents'),
            isActive: _currentStep >= 3,
            state: StepState.indexed,
            content: _documentUi()),
        new Step(
            title: const Text('Confirm'),
            isActive: _currentStep >= 4,
            state: StepState.complete,
            content: _confirmUi()),
      ];

  var disclaimer =
      "Kindly note that the premium displayed after the computation is dependent on the values you provided and might be amended or rejected should any discrepancy be noticed at the discretion of Provident Insurance Company Limited. Please tick the box below to confirm your acceptance of this disclaimer.";
  var discliamerTerms = false;
  bool _reportedToPolice = false;
  bool _ownerOnBoard = false;
  bool _passengerOnBoard = false;
  bool _otherInvolvedInAccident = false;
  bool _damagedToOtherProperties = false;
  bool _othersInjured = false;
  bool _otherDriverDiscloseInsurance = false;
  bool _cliamAgainstYou = false;

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

//MARK: show date picker
  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        this._selectedAccidentDateDisplay =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  //MARK: show time picker
  void _selectAccidentTimeDate() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        this._selectedAccidentTimeDisplay = "${picked.hour}:${picked.minute}";
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
                        Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(width: 1.0, color: Colors.grey)),
                            child: TextButton(
                                onPressed: () {
                                  _selectDate();
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
                        ),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 0, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      width: 1.0, color: Colors.grey)),
                              child: TextButton(
                                  onPressed: () {
                                    _selectAccidentTimeDate();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        _selectedAccidentTimeDisplay,
                                        textAlign: TextAlign.left,
                                      ),
                                      Expanded(child: Container()),
                                      Icon(
                                        Icons.date_range_outlined,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            )),
                        new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
                          child: new TextFormField(
                            controller: _vehicleNumberController,
                            autofocus: false,
                            decoration: AppInputDecorator.boxDecorate(
                                "Vehicle registration no."),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                          child: new TextFormField(
                            controller: _damageController,
                            autofocus: false,
                            decoration: AppInputDecorator.boxDecorate(
                                "Damage to vehicle"),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                          child: new TextFormField(
                            controller: _placeOfAccidentController,
                            autofocus: false,
                            decoration: AppInputDecorator.boxDecorate(
                                "Place of accident"),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                          child: new TextFormField(
                            controller: _descriptionOfAccidentController,
                            autofocus: false,
                            decoration: AppInputDecorator.boxDecorate(
                                "Description of accident"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Container(
                          child: DropdownButton<String>(
                            value: _vehicleLocaton,
                            isExpanded: true,
                            hint: Text('Location of Damaged Vehicle'),
                            items: this._vehicleLocatons.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                this._vehicleLocaton = value.toString();
                              });
                            },
                          ),
                        ),
                        new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                          child: new TextFormField(
                            controller: _addressOfDamagedVehicleController,
                            autofocus: false,
                            decoration: AppInputDecorator.boxDecorate(
                                "Address of Damage Vehicle"),
                            keyboardType: TextInputType.text,
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

  //MARK: vehicle ui section
  Widget _driverInfoUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _nameOfDriverController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Driver's Full Name"),
            keyboardType: TextInputType.name,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _addressOfDriverController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Address of Driver"),
            keyboardType: TextInputType.name,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _phoneOfDriverController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Driver's Phone Number"),
            keyboardType: TextInputType.name,
          ),
        ),
        _passengerOnBoard
            ? new Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16.0),
                child: new TextFormField(
                  controller: _passengerDetailsController,
                  autofocus: false,
                  decoration:
                      AppInputDecorator.boxDecorate("Details of Passengers"),
                  keyboardType: TextInputType.text,
                ),
              )
            : Container(),
        _otherDriverDiscloseInsurance
            ? new Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16.0),
                child: new TextFormField(
                  controller: _otherDriversInsuranceCompanyController,
                  autofocus: false,
                  decoration: AppInputDecorator.boxDecorate(
                      "Other Driver's Insurance Company"),
                  keyboardType: TextInputType.text,
                ),
              )
            : Container(),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16.0),
          child: new TextFormField(
            controller: _otherPartiesDetailController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Other Party's Detail"),
            keyboardType: TextInputType.text,
          ),
        ),
        _damagedToOtherProperties
            ? new Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                child: new TextFormField(
                  controller: _damageCausedToOtherDetailController,
                  autofocus: false,
                  decoration: AppInputDecorator.boxDecorate(
                      "Damage Caused to Other Property"),
                  keyboardType: TextInputType.text,
                ),
              )
            : Container(),
        _otherInvolvedInAccident
            ? new Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                child: new TextFormField(
                  controller: _injuredPersonDetailController,
                  autofocus: false,
                  decoration:
                      AppInputDecorator.boxDecorate("Injured Person Details"),
                  keyboardType: TextInputType.text,
                ),
              )
            : Container(),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _policeStationDetailController,
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Police Station Details"),
            keyboardType: TextInputType.text,
          ),
        )
      ],
    ));
  }

  Widget _checkActionsUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        Container(
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Were passengers on board ?"),
            value: _passengerOnBoard,
            onChanged: (newValue) {
              setState(() {
                _passengerOnBoard = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Container(
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title:
                Text("Did other driver disclose his/her insurance company ?"),
            value: _otherDriverDiscloseInsurance,
            onChanged: (newValue) {
              setState(() {
                _otherDriverDiscloseInsurance = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Container(
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Were other involved in the acccident ?"),
            value: _otherInvolvedInAccident,
            onChanged: (newValue) {
              setState(() {
                _otherInvolvedInAccident = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Container(
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Was incident reported to the police ?"),
            value: _reportedToPolice,
            onChanged: (newValue) {
              setState(() {
                _reportedToPolice = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Container(
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Was vehicle owner on vehicle ?"),
            value: _ownerOnBoard,
            onChanged: (newValue) {
              setState(() {
                _ownerOnBoard = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Container(
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Was damage caused to other properties ?"),
            value: _damagedToOtherProperties,
            onChanged: (newValue) {
              setState(() {
                _damagedToOtherProperties = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Container(
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Were other persons injured ?"),
            value: _othersInjured,
            onChanged: (newValue) {
              setState(() {
                _othersInjured = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Container(
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Has any claim been made against you ?"),
            value: _cliamAgainstYou,
            onChanged: (newValue) {
              setState(() {
                _cliamAgainstYou = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
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
      SizedBox(
        height: 16,
      ),
      GestureDetector(
        onTap: () {
          pickFile();
        },
        child: new Container(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
          decoration: BoxDecoration(
              border: Border.all(color: secondaryColor.withAlpha(50), width: 5),
              shape: BoxShape.rectangle,
              color: Colors.grey.withAlpha(100)),
          child: Column(
            children: [
              claimFile == null
                  ? Icon(
                      Icons.file_copy_outlined,
                      size: 40,
                      color: Colors.grey,
                    )
                  : Text(
                      claimFile!.absolute.path.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
              Text(
                "Click to upload letter of claim",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      GestureDetector(
        onTap: () {
          pickImage(ImagePickerType.DRIVERS_LICENSE_FRONT);
        },
        child: new Container(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
          decoration: BoxDecoration(
              border: Border.all(color: secondaryColor.withAlpha(50), width: 5),
              shape: BoxShape.rectangle,
              color: Colors.grey.withAlpha(100)),
          child: Column(
            children: [
              licenseFrontFile == null
                  ? Icon(
                      Icons.file_copy_outlined,
                      size: 40,
                      color: Colors.grey,
                    )
                  : Image.file(
                      licenseFrontFile!,
                      height: 40,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
              Text(
                "Click to upload driver's license front",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      GestureDetector(
        onTap: () {
          pickImage(ImagePickerType.DRIVERS_LICENSE_BACK);
        },
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
                "Click to upload drivers license back",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      GestureDetector(
        onTap: () {
          pickImage(ImagePickerType.PIC_OF_DAMAGED_VEHICLE);
        },
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
                "Click to upload picture of damaged vehicle showing registration number plate",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      GestureDetector(
        onTap: () {
          pickImage(ImagePickerType.OTHER_DAMAGED_VEHICLE);
        },
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
                "Click to upload picture of damaged third party vehicle showing registration number plate",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      GestureDetector(
        onTap: () {
          pickImage(ImagePickerType.REPAIRERS_ESTIMATE);
        },
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
                "Click to upload picture of repairer's estimate",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
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

  User user = new User();

  static final String _defVehicleLocaton = "Choose Vehicle Location";
  String _vehicleLocaton = _defVehicleLocaton;
  List<String> _vehicleLocatons = [
    _defVehicleLocaton,
    "REPAIRER’S SHOP",
    "POLICE STATION",
    "OTHER"
  ];

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });

    _updateUser(true);
  }

  _updateUser(bool fetchData) {
    DBOperations().getUser().then((value) {
      setState(() {
        this.user = value;
      });
    });
  }

  Widget _buildMainContentView(BuildContext buildContext) {
    return new SafeArea(
      child: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32, top: 32),
              child: Text("Provide the following information to file a claim."),
            ),
            new Stepper(
              physics: ClampingScrollPhysics(),
              steps: steps,
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: () {
                setState(() {
                  this.handleStepClicks(buildContext);
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
        ),
      ),
    );
  }

  void handleStepClicks(BuildContext buildContext) {
    if (_currentStep == 0) {
      var noTimeSelected =
          _defAccidentTimeDisplay == _selectedAccidentTimeDisplay;
      var noDateSelected =
          _defAccidentDateDisplay == _selectedAccidentDateDisplay;
      var damageToVehicle = _damageController.text.trim();
      var regNo = _vehicleNumberController.text.trim();
      var noLocationProvided = _vehicleLocaton == _defVehicleLocaton;
      var addressOfDamage = _addressOfDamagedVehicleController.text.trim();

      if (noDateSelected || noTimeSelected) {
        this._showMessage("Select date and time of accident");
      } else if (!Validator().isValidInput(regNo)) {
        this._showMessage("State vehicle registeration number");
      } else if (!Validator().isValidInput(damageToVehicle)) {
        this._showMessage("State the damage caused");
      } else if (noLocationProvided) {
        this._showMessage("Enter location of damaged vehicle");
      } else if (!Validator().isValidInput(addressOfDamage)) {
        this._showMessage("Enter address of damaged vehicle");
      } else {
        //MARK: continue to next
        this.increaseStepper();
      }
    } else if (_currentStep == 1) {
      this.increaseStepper();
    } else if (_currentStep == 2) {
      var driversName = _nameOfDriverController.text.trim();
      var driversAddress = _addressOfDriverController.text.trim();
      var driversPhone = _phoneOfDriverController.text.trim();
      var detailOfPassenger = _passengerDetailsController.text.trim();
      if (!Validator().isValidInput(driversName)) {
        this._showMessage("Enter driver's name");
      } else if (!Validator().isValidInput(driversAddress)) {
        this._showMessage("Enter driver's address");
      } else if (!Validator().isValidInput(driversPhone)) {
        this._showMessage("Enter driver's phone");
      } else if (_passengerOnBoard &&
          !Validator().isValidInput(detailOfPassenger)) {
        this._showMessage("Enter passenger details");
      } else {
        //MARK: continue to next
        this.increaseStepper();
      }
    } else if (_currentStep == 3) {
      this.increaseStepper();
    } else if (_currentStep == 4) {
      this._checkAllRecordsAndSubmit(buildContext);
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

  void _checkAllRecordsAndSubmit(BuildContext buildContext) {
    var driversName = _nameOfDriverController.text.trim();
    var driversAddress = _addressOfDriverController.text.trim();
    var driversPhone = _phoneOfDriverController.text.trim();
    var detailOfPassenger = _passengerDetailsController.text.trim();

    var timeSelected = _selectedAccidentTimeDisplay;
    var dateSelected = _selectedAccidentDateDisplay;
    var damageToVehicle = _damageController.text.trim();
    var regNo = _vehicleNumberController.text.trim();
    var description = _descriptionOfAccidentController.text.trim();
    var locationProvided = _vehicleLocaton;
    var addressOfDamage = _addressOfDamagedVehicleController.text.trim();
    var policeStationDetail = _policeStationDetailController.text.trim();
    var otherDriversInsurance =
        _otherDriversInsuranceCompanyController.text.trim();
    var injuredPersonDetail = _injuredPersonDetailController.text.trim();
    var otherParties = _otherPartiesDetailController.text.trim();
    var damagedCaused = _damageCausedToOtherDetailController.text.trim();

    final progress = ProgressHUD.of(buildContext);
    progress?.show();

    Map<String, String> data = new Map();
    data.putIfAbsent("time_of_accident", () => timeSelected);
    data.putIfAbsent("vehicle_registration_number", () => regNo);
    data.putIfAbsent("damage_to_vehicle", () => damageToVehicle);
    data.putIfAbsent("date_of_accident", () => dateSelected);
    data.putIfAbsent("place_of_acident", () => locationProvided);
    data.putIfAbsent("description_of_accident", () => description);
    data.putIfAbsent("location_of_damaged_vehicle", () => locationProvided);
    data.putIfAbsent("address_of_damaged_vehicle", () => addressOfDamage);
    data.putIfAbsent(
        "was_vehicle_owner_on_vehicle", () => _ownerOnBoard ? "YES" : "NO");
    data.putIfAbsent("name_of_driver", () => driversName);
    data.putIfAbsent("address_of_driver", () => driversAddress);
    data.putIfAbsent("phone_number_of_driver", () => driversPhone);
    data.putIfAbsent("was_incident_report_to_police",
        () => _reportedToPolice ? "YES" : "NO");
    data.putIfAbsent("police_station_details", () => policeStationDetail);
    data.putIfAbsent(
        "were_passengers_in_vehicle", () => _passengerOnBoard ? "YES" : "NO");
    data.putIfAbsent("details_of_passengers", () => detailOfPassenger);
    data.putIfAbsent("were_others_involved_in_accident",
        () => _otherInvolvedInAccident ? "YES" : "NO");
    data.putIfAbsent("other_parties_details", () => otherParties);
    data.putIfAbsent("was_damaged_caused_to_other_properties",
        () => _damagedToOtherProperties ? "YES" : "NO");
    data.putIfAbsent(
        "damaged_caused_to_other_properties_details", () => damagedCaused);
    data.putIfAbsent(
        "were_other_persons_injured", () => _othersInjured ? "YES" : "NO");
    data.putIfAbsent("injured_persons_details", () => injuredPersonDetail);
    data.putIfAbsent("did_other_driver_disclose_insurance_company",
        () => _otherDriverDiscloseInsurance ? "YES" : "NO");
    data.putIfAbsent(
        "other_driver_insurance_company_name", () => otherDriversInsurance);
    data.putIfAbsent("has_any_claim_been_made_against_you",
        () => _cliamAgainstYou ? "YES" : "NO");

    List<File?> filesToUpload = [
      claimFile,
      licenseFrontFile,
      licenseBackFile,
      damagedVehicleFile,
      otherDamagedVehicleFile,
      otherPropertyFile,
      estimateFile
    ];

    List<String> fileKeysToUpload = [
      "claim_file",
      "driver_license_front",
      "driver_license_back",
      "picture_of_damaged_vehicle",
      "picture_of_third_party_damaged_vehicle",
      "other_damaged_properties",
      "repairers_estimate"
    ];

    ApiService.get(this.user.token)
        .uploadFiles(
            "POST", ApiUrl().fileClaim(), filesToUpload, fileKeysToUpload, data)
        .then((value) {
      String responseCode = value["response_code"].toString();
      String message = "";
      if (responseCode == "100") {
        message = value["message"].toString();
      } else {
        message = value["detail"].toString();
      }
      PopUpHelper(context, "File Claim", message).showMessageDialogWith("OK",
          () {
        if (responseCode == "100") {
          Navigator.pop(context);
        }
      });
    }).whenComplete(() {
      progress?.dismiss();
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Policy", "Failed to request for claim")
          .showMessageDialog("OK");
    });
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      claimFile = File(result.files.single.path!);
    }
  }

  void pickImage(ImagePickerType type) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);
      if (type == ImagePickerType.DRIVERS_LICENSE_FRONT) {
        licenseFrontFile = imageFile;
      } else if (type == ImagePickerType.DRIVERS_LICENSE_BACK) {
        licenseBackFile = imageFile;
      } else if (type == ImagePickerType.DRIVERS_LICENSE_BACK) {
        licenseBackFile = imageFile;
      } else if (type == ImagePickerType.PIC_OF_DAMAGED_VEHICLE) {
        damagedVehicleFile = imageFile;
      } else if (type == ImagePickerType.OTHER_DAMAGED_VEHICLE) {
        otherDamagedVehicleFile = imageFile;
      } else if (type == ImagePickerType.REPAIRERS_ESTIMATE) {
        estimateFile = imageFile;
      } else if (type == ImagePickerType.OTHER_DAMAGED_PROPERTY) {
        otherPropertyFile = imageFile;
      }
    }
  }
}
