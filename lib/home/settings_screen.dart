import 'package:flutter/material.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import '../constants/color.dart';
import '../constants/image_resource.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User user = new User();

  @override
  void initState() {
    DBOperations().getUser().then((value) {
      print(value);
      setState(() {
        this.user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Column(
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: secondaryColor.withAlpha(50), width: 5),
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(100)),
                    child: ClipOval(
                      child: this.user.avatar.isEmpty
                          ? Image.asset(
                              ImageResource.appLogoSmall,
                              fit: BoxFit.scaleDown,
                              width: 100,
                              height: 100,
                            )
                          : new Image(
                              image:
                                  CachedNetworkImageProvider(this.user.avatar),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    this.user.fullName,
                    style: WidgetHelper.textStyle20AcensWhite,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    this.user.email,
                    style: WidgetHelper.textStyle12White,
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Container()),
          Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent, width: 0),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              child: Container(
                  child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                      ),
                      child: ListTile(
                        title: Text("Privacy & Security"),
                        leading: Icon(
                          Icons.privacy_tip,
                          size: 32,
                          color: Colors.blue,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0)),
                      ),
                      child: ListTile(
                        title: Text("About Us"),
                        leading: Icon(
                          Icons.compress_outlined,
                          size: 32,
                          color: Colors.green,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0)),
                      ),
                      child: ListTile(
                        title: Text("Help & Support"),
                        leading: Icon(
                          Icons.help_center_outlined,
                          size: 32,
                          color: Colors.indigo,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0)),
                      ),
                      child: ListTile(
                        title: Text("Contact Us"),
                        leading: Icon(
                          Icons.contact_phone_outlined,
                          size: 32,
                          color: Colors.orange,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                      ),
                      child: ListTile(
                        title: Text("Terms & Conditions"),
                        leading: Icon(
                          Icons.policy_outlined,
                          size: 32,
                          color: Colors.red,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          )
        ],
      ),
    );
  }
}
