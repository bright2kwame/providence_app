import 'package:flutter/material.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import '../constants/color.dart';
import '../constants/image_resource.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: secondaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150,
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
                          child: new Image(
                            image: AssetImage(ImageResource.appLogo),
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "Kwame Dela",
                        style: WidgetHelper.textStyle20AcensWhite,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "bright_senior_provident.com.gh",
                        style: WidgetHelper.textStyle12White,
                      ),
                    )
                  ],
                ),
              ),
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
                            side:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                          ),
                          child: ListTile(
                            title: Text("Profile Settings"),
                            subtitle: Text("change profile Settings"),
                            leading: Icon(
                              Icons.account_circle_outlined,
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
                            side:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0)),
                          ),
                          child: ListTile(
                            title: Text("Phone Number Settings"),
                            subtitle: Text("change phone number"),
                            leading: Icon(
                              Icons.phone_iphone,
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
                            side:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                          ),
                          child: ListTile(
                            title: Text("Logout"),
                            subtitle: Text("log out of account"),
                            leading: Icon(
                              Icons.logout_outlined,
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
        ));
  }
}
