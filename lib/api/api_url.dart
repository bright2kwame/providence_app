class ApiUrl {
  //MARK: get the base url
  String getBaseUrl() {
    var baseTestUrl =
        "https://provident-middleware-api.herokuapp.com/api/v1.0/";
    var baseLiveUrl =
        "https://provident-middleware-api.herokuapp.com/api/v1.0/";
    const bool _kReleaseMode = const bool.fromEnvironment("dart.vm.product");
    return _kReleaseMode ? baseTestUrl : baseLiveUrl;
  }

  //MARK: check number url
  String checkPhone() {
    return getBaseUrl() + "users/check_phone_number/";
  }

  //MARK: verify number url
  String verifyPhoneumber() {
    return getBaseUrl() + "users/verify_phone_number/";
  }

  //MARK: verify number url
  String resendVerificationCode() {
    return getBaseUrl() + "users/resend_signup_verification/";
  }

  //MARK: complete sign up url
  String completeSignUp() {
    return getBaseUrl() + "users/complete_signup/";
  }

  //MARK: saving player id
  String playerId() {
    return getBaseUrl() + "users/save_player_id/";
  }

  //MARK: my profile url
  String myProfile() {
    return getBaseUrl() + "users/me/";
  }

  //MARK: change password
  String changePassword() {
    return getBaseUrl() + "users/change_password/";
  }

  //MARK: init password reset
  String initPasswordReset() {
    return getBaseUrl() + "users/reset_password_send_sms/";
  }

  //MARK: password reset
  String resetPassword() {
    return getBaseUrl() + "users/reset_password/";
  }

  //MARK: login
  String login() {
    return getBaseUrl() + "users/login/";
  }

  //MARK: update avatar
  String updateAvatar() {
    return getBaseUrl() + "users/update_user_avatar/";
  }

  //MARK: manage policy
  String managePolicy() {
    return getBaseUrl() + "users/get_managed_policies/";
  }

  //MARK: add existing policy
  String addExistingPolicy() {
    return getBaseUrl() + "users/add_existing_policy/";
  }

  //MARK: buy policy
  String buyPolicy() {
    return getBaseUrl() + "users/buy_policy/";
  }

  //MARK: vehicle types
  String getVehicleTypes() {
    return getBaseUrl() + "users/get_vehicle_types/";
  }

  //MARK: vehicle makes
  String getVehicleMakes() {
    return getBaseUrl() + "users/get_vehicle_make/";
  }

  //MARK: vehicle makes
  String getVehicleBodyTpe() {
    return getBaseUrl() + "users/get_vehicle_body_type/";
  }

  //MARK: renew policy
  String renewPolicy() {
    return getBaseUrl() + "users/renew_policy/";
  }

  //MARK: file claim
  String fileClaim() {
    return getBaseUrl() + "users/file_claim/";
  }

  //MARK: payments
  String payments() {
    return getBaseUrl() + "users/payment_transactions/";
  }

  //MARK: get policy
  String getExistingPolicy() {
    return getBaseUrl() + "users/get_existing_policy/";
  }

  //MARK: get policy sticker
  String getPolicySticker() {
    return getBaseUrl() + "users/download_sticker/";
  }

  //MARK: get email quote
  String getEmailPolicyQuote() {
    return getBaseUrl() + "users/email_quote/";
  }

  //MARK: get quote
  String getQuoteUrl() {
    return getBaseUrl() + "users/get_quote/";
  }

  //MARK: get occupations
  String getOccupationsUrl() {
    return getBaseUrl() + "users/get_occupation/";
  }

  //MARK: get industries
  String getIndustryUrl() {
    return getBaseUrl() + "users/get_industry/";
  }
}
