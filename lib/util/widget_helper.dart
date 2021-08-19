import 'package:flutter/material.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';

class WidgetHelper {
  static get textHintStyle => TextStyle(
      color: Colors.grey, fontFamily: TextConstant.roboto, fontSize: 16.0,fontWeight: FontWeight.normal);

  static get underlineInputBorder => new UnderlineInputBorder(
      borderSide: new BorderSide(color: Colors.black26));

static get textStyle16Acens =>
      new TextStyle(fontSize: 16.0, fontFamily: TextConstant.roboto ,color: Colors.black);

static get textStyle16AcensColored =>
      new TextStyle(fontSize: 16.0, fontFamily: TextConstant.roboto ,color: const Color(0xFF4873A6));

static get textStyle16AcensWhite =>
      new TextStyle(fontSize: 16.0, fontFamily: TextConstant.roboto ,color: Colors.white);

static get textStyle32AcensWhite =>
      new TextStyle(fontSize: 32.0, fontFamily: TextConstant.roboto ,color: Colors.white);      

static get textStyle20AcensWhite =>
      new TextStyle(fontSize: 20.0, fontFamily: TextConstant.roboto ,color: Colors.white);      

static get textStyle16 =>
      new TextStyle(fontSize: 16.0, fontFamily: TextConstant.roboto ,color: Colors.black);

static get textStyle16Colored =>
      new TextStyle(fontSize: 16.0, fontFamily: TextConstant.roboto ,color: const Color(0xFF4873A6));

static get textStyle20Colored =>
      new TextStyle(fontSize: 20.0, fontFamily: TextConstant.roboto ,color: const Color(0xFF4873A6));

static get textStyle12Colored =>
      new TextStyle(fontSize: 12.0, fontFamily: TextConstant.roboto ,color: const Color(0xFF4873A6),fontWeight: FontWeight.w300);

static get textStyle20 =>
      new TextStyle(fontSize: 20.0, fontFamily: TextConstant.roboto ,color: Colors.black);

static get textStyle20Gray =>
      new TextStyle(fontSize: 20.0, fontFamily: TextConstant.roboto ,color: Colors.grey);

static get textStyle12LightDark =>
      new TextStyle(fontSize: 12.0, fontFamily: TextConstant.roboto ,color: Colors.grey);

static get textStyle12White =>
      new TextStyle(fontSize: 12.0, fontFamily: TextConstant.roboto ,color: Colors.white);

  static get textStyle16LightGray =>
      new TextStyle(fontSize: 16.0, fontFamily: TextConstant.roboto ,color: Colors.grey, fontWeight: FontWeight.w300);

  static get textStyle20LightGray =>
      new TextStyle(fontSize: 20.0, fontFamily: TextConstant.roboto ,color: Colors.grey);

  static get textStyle12 =>
      new TextStyle(fontSize: 12.0, fontFamily: TextConstant.roboto ,color: Colors.black);

  static get textStyle16White =>
      new TextStyle(fontSize: 16.0, fontFamily: TextConstant.roboto ,color: Colors.white);

static get textStyle16Black =>
      new TextStyle(fontSize: 20.0, fontFamily: TextConstant.roboto ,color: Colors.black);

  static get textStyleRegular20 =>
      new TextStyle(fontSize: 20.0, fontFamily: TextConstant.roboto ,color: Colors.black);

  static get textStyleBoldWhite20 =>
      new TextStyle(fontSize: 20.0, fontFamily: TextConstant.roboto ,color: Colors.white);

  static final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: secondaryColor,
  minimumSize: Size(100, 50),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
}
