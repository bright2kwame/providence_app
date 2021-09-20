import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widget_helper.dart';

class PopUpHelper {
  BuildContext context;
  String title;
  String message;

  PopUpHelper(this.context, this.title, this.message);

  void _showBaseMessageDialog(String action, Function() actionTaken) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            this.title,
            style: WidgetHelper.textStyle16Colored,
            textAlign: TextAlign.center,
          ),
          content: new Container(
              child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(
                      left: 0.0, top: 0.0, right: 0.0, bottom: 8.0)),
              new Text(
                this.message,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
              ),
              new Padding(
                  padding: EdgeInsets.only(
                      left: 0.0, top: 10.0, right: 0.0, bottom: 10.0)),
              new TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  actionTaken();
                },
                child: Text(
                  action,
                  textAlign: TextAlign.center,
                  style: WidgetHelper.textStyle16AcensColored,
                ),
              ),
            ],
          )),
        );
      },
    );
  }

  void showIconDialog(String action, Function() actionTaken) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            this.title,
            style: WidgetHelper.textStyle20Colored,
            textAlign: TextAlign.center,
          ),
          content: new Container(
              child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(
                      left: 0.0, top: 0.0, right: 0.0, bottom: 8.0)),
              new Text(
                this.message,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.center,
              ),
              new Padding(
                  padding: EdgeInsets.only(
                      left: 0.0, top: 10.0, right: 0.0, bottom: 10.0)),
              new IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.done),
                color: Colors.red,
                iconSize: 30,
              )
            ],
          )),
        );
      },
    );
  }

  void showMessageDialog(String action) {
    this._showBaseMessageDialog(action, () => {});
  }

  showMessageDialogWith(String action, [function]) {
    this._showBaseMessageDialog(action, function);
  }
}
