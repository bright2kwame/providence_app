import 'package:flutter/material.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/util/widget_helper.dart';

class VehicleColorPicker extends StatefulWidget {
  VehicleColorPicker({Key? key}) : super(key: key);

  @override
  _VehicleColorPickerState createState() => _VehicleColorPickerState();
}

class _VehicleColorPickerState extends State<VehicleColorPicker> {
  List<String> _vehicleColors = [];
  List<String> _vehicleColorsFilter = [];
  List<String> _vehicleColorsDefault = [];
  String searchString = "";
  User user = new User();

  @override
  void initState() {
    super.initState();

    DBOperations().getUser().then((value) {
      setState(() {
        this.user = value;
      });
      this._getVehicleColors(ApiUrl().getColors());
    });
  }

  _getVehicleColors(String url) {
    ApiService.get(this.user.token)
        .getData(url)
        .then((value) {
          List<String> data = [];
          value["results"].forEach((item) {
            data.add(item["name"].toString());
          });
          setState(() {
            this._vehicleColors.addAll(data);
            this._vehicleColorsDefault.addAll(data);
          });
          if (value["next"] != null) {
            _getVehicleColors(value["next"].toString());
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

  void searchList(String text) {
    _vehicleColorsFilter.clear();
    _vehicleColorsDefault.forEach((item) {
      if (item.toLowerCase().contains(text)) {
        _vehicleColorsFilter.add(item);
      }
    });

    setState(() {
      _vehicleColors = _vehicleColorsFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "VEHICLE COLOR",
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
                  String vehicleColor = _vehicleColors[position];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, vehicleColor);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: Text(vehicleColor),
                    ),
                  );
                },
                separatorBuilder: (context, position) {
                  return Divider();
                },
                itemCount: _vehicleColors.length,
              ),
            ])));
  }
}
