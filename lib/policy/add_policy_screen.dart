import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/api/parse_data.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/model/vehicle_things_model.dart';
import 'package:provident_insurance/policy/vehicle_color_picker.dart';
import 'package:provident_insurance/policy/vehicle_make_picker.dart';
import 'package:provident_insurance/policy/vehicle_type_picker.dart';
import 'package:provident_insurance/util/pop_up_helper.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AddPolicyScreen extends StatefulWidget {
  final bool isQuote;
  AddPolicyScreen(this.isQuote);
  @override
  State<StatefulWidget> createState() {
    return _AddPolicyScreenState();
  }
}

class _AddPolicyScreenState extends State<AddPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isQuote ? "GET QUOTE" : "NEW POLICY",
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

/*personal*/
  static TextEditingController _firstNameController =
      new TextEditingController();
  static TextEditingController _lastNameController =
      new TextEditingController();
  static TextEditingController _middleNameController =
      new TextEditingController();
  static TextEditingController _phoneNumberController =
      new TextEditingController();
  static TextEditingController _agentNumberController =
      new TextEditingController();
  static TextEditingController _emailAddressController =
      new TextEditingController();

  /*driver section*/
  static TextEditingController _sumInsuredController =
      new TextEditingController();

  static int _currentStep = 0;
  static var _focusNode = new FocusNode();

  List<Step> get steps => <Step>[
        new Step(
            title: const Text('Personal Basic'),
            isActive: _currentStep >= 0,
            state: StepState.indexed,
            content: _personalUi()),
        new Step(
            title: const Text('Personal KYC'),
            isActive: _currentStep >= 1,
            state: StepState.indexed,
            content: _personalKYCUi()),
        new Step(
            title: const Text('Insurance'),
            isActive: _currentStep >= 2,
            state: StepState.indexed,
            content: _insuranceUi()),
        new Step(
            title: const Text('Vehicle Select'),
            isActive: _currentStep >= 3,
            state: StepState.indexed,
            content: _vehicleUi()),
        new Step(
            title: const Text('Vehicle Input'),
            isActive: _currentStep >= 4,
            state: StepState.indexed,
            content: _vehicleInputUi()),
        new Step(
            title: const Text('Extra Info'),
            isActive: _currentStep >= 5,
            state: StepState.indexed,
            content: _companyInputUi()),
        new Step(
            title: const Text('Confirm'),
            isActive: _currentStep >= 6,
            state: StepState.complete,
            content: _agentsInputUi()),
      ];

  String _selectedDateOfBirthDisplay = "Date of Birth";

  static final String _defInsuranceType = "Select Insurance Type";
  String _insuranceType = _defInsuranceType;
  var _insuranceTypes = [
    _defInsuranceType,
    "Comprehensive",
    "Third Party",
    "Third Party, Fire and Theft",
  ];
  var _insuranceTypeKeys = [
    _defInsuranceType,
    "COMPREHENSIVE",
    "THIRD_PARTY",
    "THIRD_PARTY_FIRE_THEFT"
  ];

  static final String _defTransimissionType = "Select Transmission Type";
  String _transmissionMode = _defTransimissionType;
  var _transmissionModes = [_defTransimissionType, "Manual", "Automatic"];
  var __transmissionModeKeys = [
    _defInsuranceType,
    "MANUAL",
    "AUTOMATIC",
  ];

  static final String _defMotorPoer = "Select Motive Power";
  String _motivePower = _defMotorPoer;

  var _motivePowers = [
    _defMotorPoer,
    "Petrol",
    "Gas",
    "Electricity",
    "Diesel",
    "Hybrid",
    "Solar",
    "Petro/Gas",
    "Other"
  ];

  var _motivePowersKeys = [
    _defInsuranceType,
    "PETROL",
    "GAS",
    "ELECTRICITY",
    "DIESEL",
    "HYBRID",
    "SOLAR",
    "PETRO/GAS",
    "OTHER"
  ];

  static final String _defInsurancePeriod = "Select Insurance Period";
  String _insurancePeriod = _defInsurancePeriod;

  var _insurancePeriods = [
    _defInsurancePeriod,
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];

  var _insurancePeriodsKeys = [
    _defInsurancePeriod,
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];

  static final String _defIDTypeType = "Select ID Type";
  String _idType = _defIDTypeType;
  var _idTypes = [
    _defIDTypeType,
    "Ghana card",
    "Passport",
    "Voters",
    "Driving License",
  ];
  var __idTypeKeys = [
    _defIDTypeType,
    "GHANA_CARD",
    "PASSPORT",
    "VOTERS",
    "DRIVING_LICENSE"
  ];
  var __idTypeBusiness = [
    _defIDTypeType,
    "CERTIFICATE OF INCORPORATION",
    "CERTIFICATE OF COMMENCEMENT"
  ];

  var __idTypeBusinessKeys = [
    _defIDTypeType,
    "CERTIFICATE_OF_INCORPORATION",
    "CERTIFICATE_OF_COMMENCEMENT"
  ];

  static final String _defGenderType = "Select Gender";
  String _gender = _defGenderType;
  var _genderTypes = [
    _defGenderType,
    "Male",
    "Female",
  ];
  static final String _defPolicyType = "Choose Policy Type";
  String _policyType = _defPolicyType;
  var _policyTypes = [
    _defPolicyType,
    "BUSINESS",
    "PERSONAL",
  ];
  var __genderTypesKeys = [_defGenderType, "MALE", "FEMALE"];

  String _defVehicleType = "Select Vehicle Type";
  VehicleThings _vehicleThingsType = VehicleThings(name: "Select Vehicle Type");

  String _defVehicleMake = "Select Vehicle Make";
  VehicleThings _vehicleThingsMake = VehicleThings(name: "Select Vehicle Make");

  static final String _defVehicleBodyTye = "Select Vehicle Body Type";
  String _vehicleBodyType = _defVehicleBodyTye;
  List<VehicleThings> _vehicleBodyTypes = [
    VehicleThings(name: _defVehicleBodyTye)
  ];

  static final String _defOccupation = "Choose occupation";
  String _occupation = _defOccupation;
  List<VehicleThings> _occupations = [VehicleThings(name: _defOccupation)];

  static final String _defIndustry = "Choose industry";
  String _industry = _defIndustry;
  List<VehicleThings> _industries = [VehicleThings(name: _defIndustry)];

  String _defVehicleColor = "Select Vehicle Color";
  String _vehicleColor = "";

  /*vehicle section*/
  static TextEditingController _numberOfSeatsController =
      new TextEditingController();
  static TextEditingController _manufacturingYearController =
      new TextEditingController();
  static TextEditingController _idNumberController =
      new TextEditingController();

  /*company section*/
  static TextEditingController _companyNameController =
      new TextEditingController();
  static TextEditingController _contactMobileController =
      new TextEditingController();
  static TextEditingController _contactNameController =
      new TextEditingController();
  static TextEditingController _contactPositionController =
      new TextEditingController();

  var disclaimer =
      "Kindly note that the premium displayed after the computation is dependent on the values you provided and might be amended or rejected should any discrepancy be noticed at the discretion of Provident Insurance Company Limited. Please tick the box below to confirm your acceptance of this disclaimer.";
  var discliamerTerms = false;
  var isAgentSubmission = false;

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

//MARK: show date picker
  _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      DateTime date = new DateTime.now();
      var newDate = new DateTime(date.year - 17, date.month, date.day);
      if (picked.isAfter(newDate)) {
        _showMessage("Date of birth must be more than 18 years");
        setState(() {
          _selectedDateOfBirthDisplay = "Date of Birth";
        });
        return;
      }
      setState(() {
        _selectedDateOfBirthDisplay = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

//MARK: personal ui section
  Widget _personalUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      physics: const NeverScrollableScrollPhysics(),
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
                        Container(
                          child: DropdownButton<String>(
                            value: _policyType,
                            isExpanded: true,
                            hint: Text('Choose Policy Type'),
                            items: this._policyTypes.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                this._policyType = value.toString();
                              });
                            },
                          ),
                        ),
                        new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                          child: new TextFormField(
                            controller: _firstNameController,
                            autofocus: false,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter first name"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                          child: new TextFormField(
                            controller: _lastNameController,
                            autofocus: false,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter last name"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        new Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                          child: new TextFormField(
                            controller: _middleNameController,
                            autofocus: false,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter middle name"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 16.0),
                            child: new TextFormField(
                              autofocus: false,
                              controller: _phoneNumberController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
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
                                  this._selectDate();
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

//MARK: personal ui section
  Widget _personalKYCUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      reverse: false,
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: DropdownButton<String>(
                value: _gender,
                isExpanded: true,
                hint: Text('Choose Gender'),
                items: this._genderTypes.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    this._gender = value.toString();
                  });
                },
              ),
            ),
            this._policyType == "PERSONAL"
                ? Container(
                    child: DropdownButton<String>(
                      value: _idType,
                      isExpanded: true,
                      hint: Text('Choose ID Type'),
                      items: this._idTypes.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          this._idType = value.toString();
                        });
                      },
                    ),
                  )
                : Container(
                    child: DropdownButton<String>(
                      value: _idType,
                      isExpanded: true,
                      hint: Text('Choose ID Type'),
                      items: this.__idTypeBusiness.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          this._idType = value.toString();
                        });
                      },
                    ),
                  ),
            new Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
              child: new TextFormField(
                controller: _idNumberController,
                autofocus: false,
                decoration: AppInputDecorator.boxDecorate("Enter ID number"),
                keyboardType: TextInputType.text,
              ),
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
      physics: const NeverScrollableScrollPhysics(),
      reverse: false,
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
        ),
        Container(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _insurancePeriod,
            hint: Text('Select Insurance Period'),
            items: this._insurancePeriods.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._insurancePeriod = value.toString();
              });
            },
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _sumInsuredController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Enter sum insured"),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    ));
  }

  void _updateMake(VehicleThings value) {
    setState(() {
      this._vehicleThingsMake = value;
      this._defVehicleMake = value.name;
    });
  }

  void _updateType(VehicleThings value) {
    setState(() {
      this._vehicleThingsType = value;
      this._defVehicleType = value.name;
    });
  }

  void _updateColors(String value) {
    setState(() {
      this._vehicleColor = value;
      this._defVehicleColor = value;
    });
  }

  //MARK: vehicle ui section
  Widget _vehicleUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      reverse: false,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1.0, color: Colors.grey)),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new VehicleTypePicker()))
                      .then((value) => {
                            if (value != null) {this._updateType(value)}
                          });
                },
                child: Row(
                  children: [
                    Text(
                      _defVehicleType,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
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
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1.0, color: Colors.grey)),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new VehicleMakePicker()))
                      .then((value) => {
                            if (value != null) {this._updateMake(value)}
                          });
                },
                child: Row(
                  children: [
                    Text(
                      _defVehicleMake,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ],
                )),
          ),
        ),
        Container(
          child: DropdownButton<String>(
            value: _motivePower,
            isExpanded: true,
            hint: Text('Choose Motive Power'),
            items: this._motivePowers.map((value) {
              return DropdownMenuItem(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._motivePower = value.toString();
              });
            },
          ),
        ),
        Container(
          child: DropdownButton<String>(
            value: _vehicleBodyType,
            isExpanded: true,
            hint: Text('Choose Body Type'),
            items: this._vehicleBodyTypes.map((value) {
              return DropdownMenuItem(
                value: value.name,
                child: new Text(value.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._vehicleBodyType = value.toString();
              });
            },
          ),
        ),
        Container(
          child: DropdownButton<String>(
            value: _transmissionMode,
            isExpanded: true,
            hint: Text('Choose Transmission Type'),
            items: this._transmissionModes.map((value) {
              return DropdownMenuItem(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._transmissionMode = value.toString();
              });
            },
          ),
        ),
      ],
    ));
  }

  //MARK: vehicle input
  Widget _vehicleInputUi() {
    return Container(
        child: new ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _numberOfSeatsController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            decoration: AppInputDecorator.boxDecorate("Enter Number of Seats"),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
          child: new TextFormField(
            controller: _manufacturingYearController,
            autofocus: false,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration:
                AppInputDecorator.boxDecorate("Enter manufaturing year"),
            keyboardType: TextInputType.number,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1.0, color: Colors.grey)),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new VehicleColorPicker()))
                      .then((value) => {
                            if (value != null) {this._updateColors(value)}
                          });
                },
                child: Row(
                  children: [
                    Text(
                      _defVehicleColor,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ],
                )),
          ),
        ),
      ],
    ));
  }

  //MARK: comapany ui section
  Widget _companyInputUi() {
    return this._policyType == "PERSONAL"
        ? Container()
        : Container(
            child: new ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            reverse: false,
            children: <Widget>[
              Container(
                child: DropdownButton<String>(
                  value: _industry,
                  isExpanded: true,
                  hint: Text('Choose Industry'),
                  items: this._industries.map((value) {
                    return DropdownMenuItem(
                      value: value.name,
                      child: new Text(value.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      this._industry = value.toString();
                    });
                  },
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                child: new TextFormField(
                  controller: _companyNameController,
                  autofocus: false,
                  decoration:
                      AppInputDecorator.boxDecorate("Enter company name"),
                  keyboardType: TextInputType.text,
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                child: new TextFormField(
                  controller: _contactNameController,
                  autofocus: false,
                  decoration:
                      AppInputDecorator.boxDecorate("Enter contact name"),
                  keyboardType: TextInputType.name,
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                child: new TextFormField(
                  controller: _contactMobileController,
                  autofocus: false,
                  decoration:
                      AppInputDecorator.boxDecorate("Enter contact mobile"),
                  keyboardType: TextInputType.text,
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16),
                child: new TextFormField(
                  controller: _contactPositionController,
                  autofocus: false,
                  decoration:
                      AppInputDecorator.boxDecorate("Enter contact position"),
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                child: DropdownButton<String>(
                  value: _occupation,
                  isExpanded: true,
                  hint: Text('Choose Contact Occupation'),
                  items: this._occupations.map((value) {
                    return DropdownMenuItem(
                      value: value.name,
                      child: new Text(value.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      this._occupation = value.toString();
                    });
                  },
                ),
              ),
            ],
          ));
  }

//MARK: agents ui section
  Widget _agentsInputUi() {
    return Container(
        child: new ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      reverse: false,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
          child: CheckboxListTile(
            title: Text("Submit policy as an agent"),
            value: isAgentSubmission,
            onChanged: (newValue) {
              setState(() {
                isAgentSubmission = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        new Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16.0),
            child: new TextFormField(
              autofocus: false,
              controller: _agentNumberController,
              keyboardType: TextInputType.text,
              decoration: AppInputDecorator.boxDecorate("Enter Agent number"),
            )),
      ],
    ));
  }

  User user = new User();

  @override
  void initState() {
    this._updateUser(true);

    super.initState();

    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  //MARK: update local db
  _updateUser(bool fetchData) {
    DBOperations().getUser().then((value) {
      setState(() {
        this.user = value;
      });
      if (fetchData) {
        this._getVehicleBodyTypes(ApiUrl().getVehicleBodyTpe());
        this._getOccupation(ApiUrl().getOccupationsUrl());
        this._getIndustry(ApiUrl().getIndustryUrl());
      }
    });
  }

  _getVehicleBodyTypes(String url) {
    ApiService.get(this.user.token)
        .getData(url)
        .then((value) {
          List<VehicleThings> data = [];
          value["results"].forEach((item) {
            data.add(ParseApiData().parseThings(item));
          });
          setState(() {
            this._vehicleBodyTypes.addAll(data);
          });
          if (value["next"] != null) {
            _getVehicleBodyTypes(value["next"].toString());
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

  _getIndustry(String url) {
    ApiService.getNoAuth()
        .getDataNoAuth(url)
        .then((value) {
          print(value.toString());
          List<VehicleThings> data = [];
          value["results"].forEach((item) {
            data.add(ParseApiData().parseThing(item));
          });
          setState(() {
            this._industries.addAll(data);
          });
          if (value["next"] != null) {
            _getIndustry(value["next"].toString());
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

  _getOccupation(String url) {
    ApiService.getNoAuth()
        .getDataNoAuth(url)
        .then((value) {
          List<VehicleThings> data = [];
          value["results"].forEach((item) {
            data.add(ParseApiData().parseThing(item));
          });
          setState(() {
            this._occupations.addAll(data);
          });
          if (value["next"] != null) {
            _getOccupation(value["next"].toString());
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

  Widget _buildMainContentView(context) {
    return new SafeArea(
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 32, right: 32, top: 32),
            child: Text(widget.isQuote
                ? "Provide the following information to request a quote."
                : "Provide the following information to request a new policy."),
          ),
          new Stepper(
            physics: ClampingScrollPhysics(),
            steps: steps,
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepContinue: () {
              print(_currentStep);
              setState(() {
                if (_currentStep == 0) {
                  var firstName =
                      _firstNameController.value.text.toString().trim();
                  var lastName =
                      _lastNameController.value.text.toString().trim();
                  var number =
                      _phoneNumberController.value.text.toString().trim();

                  var email =
                      _emailAddressController.value.text.toString().trim();

                  if (!Validator().isValidName(firstName) ||
                      !Validator().isValidName(lastName)) {
                    this._showMessage("Enter a valid name");
                  } else if (_policyType.isEmpty) {
                    this._showMessage("Choose policy type");
                  } else if (!Validator().isValidPhoneNumber(number)) {
                    this._showMessage("Enter a valid number");
                  } else if (!Validator().isValidEmail(email)) {
                    this._showMessage("Enter a valid email address");
                  } else if (!Validator()
                      .isValidInput(_selectedDateOfBirthDisplay)) {
                    this._showMessage("Select date oof birth");
                  } else {
                    //MARK: continue to next
                    this.increaseStepper();
                  }
                } else if (_currentStep == 1) {
                  var selected = this._idTypes.contains(this._idType);
                  var selectedGender = this._genderTypes.contains(this._gender);
                  if (_policyType == "PERSONAL" &&
                      (_idType == _defIDTypeType || !selected)) {
                    this._showMessage("Select ID type");
                  } else if (_policyType == "BUSNESS" &&
                      (_idType == _defIDTypeType || !selected)) {
                    this._showMessage("Select gender");
                  } else if (_gender == _defGenderType || !selectedGender) {
                    this._showMessage("Select gender");
                  } else {
                    //MARK: continue to next
                    this.increaseStepper();
                  }
                } else if (_currentStep == 2) {
                  var selected =
                      this._insuranceTypes.contains(this._insuranceType);
                  var selectedperid =
                      this._insurancePeriods.contains(this._insurancePeriod);
                  if (_insuranceType == _defInsuranceType || !selected) {
                    this._showMessage("Select insurance type");
                  } else if (_insurancePeriod == _defInsurancePeriod ||
                      !selectedperid) {
                    this._showMessage("Select insurance period");
                  } else {
                    //MARK: continue to next
                    this.increaseStepper();
                  }
                } else if (_currentStep == 3) {
                  if (_vehicleThingsType.id.isEmpty) {
                    this._showMessage("Select vehicle type");
                  } else if (_vehicleThingsMake.id.isEmpty) {
                    this._showMessage("Select vehicle make");
                  } else if (_vehicleBodyType == _defVehicleBodyTye) {
                    this._showMessage("Select vehicle body");
                  } else if (_motivePower == _defMotorPoer) {
                    this._showMessage("Select motive power");
                  } else {
                    //MARK: continue to next
                    this.increaseStepper();
                  }
                } else if (_currentStep == 4) {
                  var numberOfSeats =
                      _numberOfSeatsController.text.toString().trim();
                  var maufacturingYear =
                      _manufacturingYearController.text.toString().trim();
                  var color = this._vehicleColor;
                  if (!Validator().isValidInput(numberOfSeats)) {
                    this._showMessage("Enter vehicle number of seats");
                  } else if (!Validator().isValidInput(maufacturingYear)) {
                    this._showMessage("Enter year of manufacturing");
                  } else if (!Validator().isValidInput(color)) {
                    this._showMessage("Provide color");
                  } else {
                    //MARK: continue to next
                    this.increaseStepper();
                  }
                } else if (_currentStep == 5) {
                  var companyName =
                      _companyNameController.text.toString().trim();
                  var contactName =
                      _contactNameController.text.toString().trim();
                  var contactMobile =
                      _contactMobileController.text.toString().trim();
                  var contactPosition =
                      _contactPositionController.text.toString().trim();

                  var policyIsBusiness = _policyType == "BUSINESS";
                  if (policyIsBusiness &&
                      !Validator().isValidInput(companyName)) {
                    this._showMessage("Enter company name");
                  } else if (policyIsBusiness &&
                      !Validator().isValidInput(contactName)) {
                    this._showMessage("Enter contact person name");
                  } else if (policyIsBusiness &&
                      !Validator().isValidInput(contactMobile)) {
                    this._showMessage("Enter contact person number");
                  } else if (policyIsBusiness &&
                      !Validator().isValidInput(contactPosition)) {
                    this._showMessage("Enter contact person position");
                  } else if (policyIsBusiness &&
                      _occupation == _defOccupation) {
                    this._showMessage("Enter contact person occupation");
                  } else {
                    //MARK: continue to next
                    this.increaseStepper();
                  }
                } else if (_currentStep == 6) {
                  var agentNumber =
                      _agentNumberController.text.toString().trim();
                  if (isAgentSubmission &&
                      !Validator().isValidInput(agentNumber)) {
                    this._showMessage("Enter agent number and proceed");
                  } else {
                    //MARK: continue to next
                    this._checkAllRecordsAndSubmit(context);
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
      )),
    );
  }

  void increaseStepper() {
    //MARK: continue to next
    if (_currentStep < steps.length - 1) {
      _currentStep = _currentStep + 1;
    }
  }

  void _checkAllRecordsAndSubmit(BuildContext buildContext) {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String middleName = _middleNameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();
    String agentNumber = _agentNumberController.text.trim();
    String email = _emailAddressController.text.trim();
    String color = _vehicleColor;
    String year = _manufacturingYearController.text.trim();
    String sum = _sumInsuredController.text.trim();
    String seatNo = _numberOfSeatsController.text.trim();
    String idNumber = _idNumberController.text.trim();

    String companyName = _companyNameController.text.trim();
    String contactName = _contactNameController.text.trim();
    String contactMobile = _contactMobileController.text.trim();
    String contactPosition = _contactPositionController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || middleName.isEmpty) {
      PopUpHelper(context, "Buy Policy", "Provide name information")
          .showMessageDialog("OK");
      return;
    }

    if (phoneNumber.isEmpty) {
      PopUpHelper(context, "Buy Policy", "Provide phone number")
          .showMessageDialog("OK");
      return;
    }

    if (!Validator().isValidEmail(email)) {
      PopUpHelper(context, "Buy Policy", "Enter a valid email address")
          .showMessageDialog("OK");
      return;
    }

    if (_selectedDateOfBirthDisplay == "Date of Birth") {
      PopUpHelper(context, "Buy Policy", "Provide a valid date of birth")
          .showMessageDialog("OK");
      return;
    }

    if (this._vehicleThingsType.id.isEmpty) {
      PopUpHelper(context, "Buy Policy", "Select vehicle type")
          .showMessageDialog("OK");
      return;
    }

    if (this._vehicleThingsMake.id.isEmpty) {
      PopUpHelper(context, "Buy Policy", "Select vehicle make")
          .showMessageDialog("OK");
      return;
    }

    if (this._vehicleBodyType == _defVehicleBodyTye) {
      PopUpHelper(context, "Buy Policy", "Select vehicle body")
          .showMessageDialog("OK");
      return;
    }

    if (isAgentSubmission && agentNumber.isEmpty) {
      PopUpHelper(context, "Buy Policy", "Enter agent number and proceed")
          .showMessageDialog("OK");
      return;
    }

    if (this._policyType == "BUSINESS" &&
        (companyName.isEmpty ||
            contactName.isEmpty ||
            contactMobile.isEmpty ||
            contactPosition.isEmpty)) {
      PopUpHelper(context, "Buy Policy", "Provide company info")
          .showMessageDialog("OK");
      return;
    }

    VehicleThings vehicleThingsBody = this
        ._vehicleBodyTypes
        .firstWhere((element) => element.name == this._vehicleBodyType);

    Map<String, String> data = new Map();
    data.putIfAbsent("phone_number", () => phoneNumber);
    data.putIfAbsent("agent_number", () => agentNumber);
    data.putIfAbsent("email_address", () => email);
    data.putIfAbsent("middle_name", () => middleName);
    data.putIfAbsent("first_name", () => firstName);
    data.putIfAbsent("last_name", () => lastName);
    data.putIfAbsent("date_of_birth", () => this._selectedDateOfBirthDisplay);
    data.putIfAbsent("vehicle_color", () => color);
    data.putIfAbsent(
        "insurance_period",
        () => this._insurancePeriodsKeys[
            this._insurancePeriods.indexOf(this._insurancePeriod)]);
    data.putIfAbsent("vehicle_manufacturing_year", () => year);
    data.putIfAbsent(
        "insurance_type",
        () => this._insuranceTypeKeys[
            this._insuranceTypes.indexOf(this._insuranceType)]);
    data.putIfAbsent("sum_insured", () => sum);
    data.putIfAbsent("vehicle_make", () => _vehicleThingsMake.name);

    data.putIfAbsent("vehicle_type", () => _vehicleThingsType.name);
    data.putIfAbsent(
        "motive_power",
        () => this
            ._motivePowersKeys[this._motivePowers.indexOf(this._motivePower)]);
    data.putIfAbsent("vehicle_body_type", () => vehicleThingsBody.id);
    data.putIfAbsent(
        "transmission",
        () => this.__transmissionModeKeys[
            this._transmissionModes.indexOf(this._transmissionMode)]);

    data.putIfAbsent("number_of_seats", () => seatNo);
    data.putIfAbsent("sex",
        () => this.__genderTypesKeys[this._genderTypes.indexOf(this._gender)]);
    data.putIfAbsent(
        "id_type",
        () => this._policyType == "PERSONAL"
            ? this.__idTypeKeys[this._idTypes.indexOf(this._idType)]
            : this.__idTypeBusinessKeys[
                this.__idTypeBusiness.indexOf(this._idType)]);
    data.putIfAbsent("id_number", () => idNumber);

    if (this._policyType == "BUSINESS") {
      //MARK: company
      data.putIfAbsent("company_name", () => companyName);
      data.putIfAbsent("chief_contact_name", () => contactName);
      data.putIfAbsent("chief_contact_mobile", () => contactMobile);
      data.putIfAbsent("chief_contact_position", () => contactPosition);

      VehicleThings vehicleThingsOccupaion = this
          ._occupations
          .firstWhere((element) => element.name == this._occupation);

      data.putIfAbsent(
          "chief_contact_occupation", () => vehicleThingsOccupaion.id);

      VehicleThings vehicleThingsIndustry = this
          ._industries
          .firstWhere((element) => element.name == this._industry);

      data.putIfAbsent("industry", () => vehicleThingsIndustry.id);
    }

    final progress = ProgressHUD.of(buildContext);
    progress?.show();

    ApiService.get(this.user.token)
        .postData(ApiUrl().buyPolicy(), data)
        .then((value) {
      if (widget.isQuote) {
        String amount = value["results"]["premium"];
        String quoteId = value["results"]["quote_id"];
        PopUpHelper(context, "Policy Quote", "Policy quote is " + amount)
            .showMessageDialogWith("EMAIL QUOTE", () {
          this._emailQuote(buildContext, quoteId);
        });
        return;
      }
      String amount = value["results"]["premium"];
      String paymentLink = value["results"]["payment_url"];
      PopUpHelper(context, "Policy",
              "Successfully placed purchase policy request of $amount")
          .showMessageDialogWith("PROCEED TO PAY", () {
        this._openPaymentPage(paymentLink);
      });
    }).whenComplete(() {
      progress?.dismiss();
    }).onError((error, stackTrace) {
      print(error);
      PopUpHelper(context, "Policy", "Failed to buy policy")
          .showMessageDialog("OK");
    });
  }

  //MARK: take user to terms page
  void _emailQuote(BuildContext buildContext, String id) async {
    final progress = ProgressHUD.of(buildContext);
    progress?.show();
    Map<String, String> data = new Map();
    data.putIfAbsent("quote_id", () => id);
    ApiService.get(this.user.token)
        .postData(ApiUrl().getEmailPolicyQuote(), data)
        .then((value) {
      PopUpHelper(context, "Policy Quote", "Email sent successfully")
          .showMessageDialog("OK");
    }).whenComplete(() {
      progress?.dismiss();
    }).onError((error, stackTrace) {
      print(error);
      PopUpHelper(context, "Policy", "Failed to buy policy")
          .showMessageDialog("OK");
    });
  }

  //MARK: take user to terms page
  void _openPaymentPage(String url) async {
    Navigator.pop(context);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
