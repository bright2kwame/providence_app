import 'package:flutter/material.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/api/parse_data.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/model/vehicle_things_model.dart';
import 'package:provident_insurance/util/widget_helper.dart';

class VehicleMakePicker extends StatefulWidget {
  VehicleMakePicker({Key? key}) : super(key: key);

  @override
  _VehicleMakePickerState createState() => _VehicleMakePickerState();
}

class _VehicleMakePickerState extends State<VehicleMakePicker> {
  List<VehicleThings> _vehicleMakes = [];
  List<VehicleThings> _vehicleMakesFilter = [];
  List<VehicleThings> _vehicleMakesDefault = [];
  String searchString = "";
  User user = new User();

  @override
  void initState() {
    super.initState();

    DBOperations().getUser().then((value) {
      setState(() {
        this.user = value;
      });
      this._getVehicleMakes(ApiUrl().getVehicleMakes());
    });
  }

  _getVehicleMakes(String url) {
    ApiService.get(this.user.token)
        .getData(url)
        .then((value) {
          List<VehicleThings> data = [];
          value["results"].forEach((item) {
            data.add(ParseApiData().parseThings(item));
          });
          setState(() {
            this._vehicleMakes.addAll(data);
            this._vehicleMakesDefault.addAll(data);
          });
          if (value["next"] != null) {
            _getVehicleMakes(value["next"].toString());
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

  void searchList(String text) {
    _vehicleMakesFilter.clear();
    _vehicleMakesDefault.forEach((item) {
      if (item.name.toLowerCase().contains(text)) {
        _vehicleMakesFilter.add(item);
      }
    });

    setState(() {
      _vehicleMakes = _vehicleMakesFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "VEHICLE MAKE",
            style: WidgetHelper.textStyle16AcensWhite,
          ),
          backgroundColor: secondaryColor,
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  onChanged: (value) {
                    searchList(value.toLowerCase());
                  },
                  decoration: InputDecoration(
                      labelText: 'Search', suffixIcon: Icon(Icons.search)),
                ),
              ),
              SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, position) {
                  VehicleThings vehicleThings = _vehicleMakes[position];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, vehicleThings);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: Text(vehicleThings.name),
                    ),
                  );
                },
                separatorBuilder: (context, position) {
                  return Divider();
                },
                itemCount: _vehicleMakes.length,
              ),
            ])));
  }
}
