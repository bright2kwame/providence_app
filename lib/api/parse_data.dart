import 'package:provident_insurance/model/policy_model.dart';
import 'package:provident_insurance/model/user_model.dart';

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
    String policyNumber = result["policy_number"];
    String vehicleMake = result["vehicle_make"].toString();
    String ownerName = result["owner_name"].toString();
    String renewalDate = result["renewal_date"].toString();
    bool isRenewalDue = result["is_renewal_due"];
    String colour = result["colour"].toString();
    String totalPremium = getJsonData(result, "total_premium");
    var policy = Policy(
        policyNumber: policyNumber,
        vehicleMake: vehicleMake,
        ownerName: ownerName,
        renewalDate: renewalDate,
        isRenewalDue: isRenewalDue,
        colour: colour,
        totalPremium: totalPremium);
    return policy;
  }

  String getJsonData(dynamic data, String key) {
    if (data == null || data[key] == null) {
      return "";
    }
    return data[key].toString();
  }
}
