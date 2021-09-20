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
    return getBaseUrl() + "users/​​reset_password_send_sms/";
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
}
