import 'package:flutter/material.dart';
import 'widget_helper.dart';

class AppInputDecorator {
  static InputDecoration decorate(String placeHolder) {
    return InputDecoration(
      counterText: "",
      hintText: placeHolder,
      focusedBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(color: Colors.black26)),
      border: new UnderlineInputBorder(
          borderSide: new BorderSide(color: Colors.black26)),
      hintStyle: WidgetHelper.textStyle16LightGray,
    );
  }

  static InputDecoration boxDecorate(String placeHolder) {
    return new InputDecoration(
      fillColor: Colors.white,
      hintText: placeHolder,
      hintStyle: WidgetHelper.textStyle16LightGray,
      counterText: "",
      filled: true,
      contentPadding:
          EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0, top: 16.0),
      labelText: placeHolder,
      focusedBorder: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
          borderSide:
              new BorderSide(color: const Color(0xFF0C3974), width: 0.5)),
      border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(5.0),
        ),
        borderSide: new BorderSide(
          color: Colors.black.withAlpha(10),
          width: 0.5,
        ),
      ),
    );
  }
}
