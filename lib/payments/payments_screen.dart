import 'package:flutter/material.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/api/parse_data.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/payment_model.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/util/widget_helper.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaymentsScreenState();
  }
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  User user = new User();
  List<Payment> allPayments = [];

  @override
  void initState() {
    this._updateUser(true);
    super.initState();
  }

  void _getPayments(String url) {
    ApiService.get(this.user.token)
        .getData(url)
        .then((value) {
          List<Payment> data = [];
          value["results"].forEach((item) {
            data.add(ParseApiData().parsePayment(item));
          });
          setState(() {
            this.allPayments.addAll(data);
          });
          if (value["next"] != null) {
            _getPayments(value["next"].toString());
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

//MARK: update local db
  _updateUser(bool fetchData) {
    DBOperations().getUser().then((value) {
      setState(() {
        this.user = value;
      });
      if (fetchData) {
        this._getPayments(ApiUrl().payments());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PAYMENTS",
          style: WidgetHelper.textStyle16AcensWhite,
        ),
        backgroundColor: secondaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildMainContentView(context),
    );
  }

  Widget _buildMainContentView(context) {
    return new SafeArea(
      child: this.allPayments.isEmpty
          ? Container(
              child: Center(
              child: Text("No records yet"),
            ))
          : ListView.separated(
              itemCount: allPayments.length,
              itemBuilder: (context, index) {
                Payment payment = allPayments[index];
                return ListTile(
                  leading: payment.paymentMethod == "MOMO"
                      ? Icon(Icons.phone_android)
                      : Icon(Icons.payment_outlined),
                  trailing: Text(
                    payment.transactionStatus,
                    style: WidgetHelper.textStyle12Colored,
                  ),
                  subtitle:
                      Text("Dated: " + payment.timeCreated.substring(0, 10)),
                  title: Text(
                      payment.transactionType.replaceAll("_", " ") +
                          " - GHS " +
                          payment.debitAmt,
                      style: WidgetHelper.textStyle16LightGray),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
    );
  }
}
