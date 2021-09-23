import 'package:provident_insurance/model/payment_model.dart';
import 'package:provident_insurance/model/policy_model.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/model/vehicle_things_model.dart';
import 'package:intl/intl.dart';

class ParseApiData {
//MARK: parse the user data
  User parseUser(var result) {
    int id = result["id"];
    String email = result["email"].toString();
    String lastName = result["last_name"].toString();
    String firstName = result["first_name"].toString();
    String fullName = getJsonData(result, "full_name");
    String phone = result["phone_number"].toString();
    String token = result["auth_token"].toString();
    String avatar = getJsonData(result, "user_avatar");
    var user = User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        fullName: fullName,
        email: email,
        phone: phone,
        avatar: avatar,
        token: token);
    return user;
  }

  Policy parsePolicy(var result) {
    // var policyDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    // var outputFormat = DateFormat('MM/dd/yyyy');
    String policyNumber = result["policy_number"];
    String vehicleMake = result["vehicle_make"].toString();
    String ownerName = result["owner_name"].toString();
    String extracted = result["renewal_date"].toString();
    String renewalDate = extracted.substring(0, 10);
    bool isRenewalDue = result["is_renewal_due"];
    String colour = result["colour"].toString();
    String totalPremium = getJsonData(result, "total_premium");
    String vehicleNumber = getJsonData(result, "vehicle_number");
    String certificateUrl = getJsonData(result, "certificate_url");
    String scheduleUrl = getJsonData(result, "schedule_url");

    var policy = Policy(
        policyNumber: policyNumber,
        vehicleMake: vehicleMake,
        vehicleNumber: vehicleNumber,
        ownerName: ownerName,
        renewalDate: renewalDate,
        isRenewalDue: isRenewalDue,
        colour: colour,
        totalPremium: totalPremium,
        certificateUrl: certificateUrl,
        scheduleUrl: scheduleUrl);
    return policy;
  }

  VehicleThings parseThings(var result) {
    String id = result["id"].toString();
    String name = result["name"].toString();
    var vehicleThings = VehicleThings(id: id, name: name);
    return vehicleThings;
  }

  Payment parsePayment(var result) {
    String debitAmount = result["debit_amt"].toString();
    String transactionType = result["transaction_type"].toString();
    String paymentMethod = result["payment_method"].toString();
    String timeCreated = result["time_created"].toString();
    String transactionStatus = result["transaction_status"].toString();
    var payment = Payment(
        debitAmt: debitAmount,
        transactionType: transactionType,
        paymentMethod: paymentMethod,
        transactionStatus: transactionStatus,
        timeCreated: timeCreated);

    return payment;
  }

  String getJsonData(dynamic data, String key) {
    if (data == null || data[key] == null) {
      return "";
    }
    return data[key].toString();
  }
}
