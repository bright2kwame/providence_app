import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'network_util.dart';

class ApiService {
  NetworkUtil _netUtil = new NetworkUtil();
  static final _apiService = new ApiService();
  static var basicHeaders;
  static const generalErrorMessage =
      "Something went wrong checking phone number, try again later.";
  static const noInternetConnection =
      "It appears you are offline, connect and try again.";

  static ApiService get(String token) {
    basicHeaders = {"Authorization": "Token $token"};
    return _apiService;
  }

  //MARK: get list of items
  /// @url, url to fetch data
  Future<dynamic> getData(String url) {
    return _netUtil.get(url, basicHeaders, utf8).then((dynamic data) {
      var statusCode = data["response_code"].toString();
      print("STATUS: $statusCode");
      if (statusCode == "100") {
        return data;
      } else {
        throw Exception(
            data["detail"] != null ? data["detail"] : data.toString());
      }
    });
  }

  //MARK: post data
  /// @url, url to fetch data
  Future<dynamic> postDataNoHeader(String url, Map<String, String> data) {
    Map<String, String> emptyHeader = new Map();
    return _netUtil.post(url, emptyHeader, data, utf8).then((dynamic data) {
      var statusCode = data["response_code"];
      print("STATUS: $statusCode DATA: $data");
      if (statusCode == "102" || statusCode == "100" || statusCode == "101") {
        return data;
      } else {
        throw Exception(
            data["detail"] != null ? data["detail"] : data.toString());
      }
    });
  }

  //MARK: post data
  /// @url, url to fetch data
  Future<dynamic> postData(String url, Map<String, String> data) {
    return _netUtil.post(url, basicHeaders, data, utf8).then((dynamic data) {
      var statusCode = data["response_code"];
      print("STATUS: $statusCode DATA: $data");
      if (statusCode == "100") {
        return data;
      } else {
        throw Exception(
            data["detail"] != null ? data["detail"] : data.toString());
      }
    });
  }

  //MARK: put data
  /// @url, url to fetch data
  Future<dynamic> putData(String url, Map<String, String> data) {
    return _netUtil.put(url, basicHeaders, data, utf8).then((dynamic data) {
      print(basicHeaders);
      var statusCode = data["response_code"];
      print("STATUS: $statusCode DATA: $data");
      if (statusCode == "100") {
        return data;
      } else {
        throw Exception(
            data["detail"] != null ? data["detail"] : data.toString());
      }
    });
  }

  //MARK: upload image to server
  Future<StreamedResponse> uploadAvatar(String httpMethod, String url,
      String uploadKey, File imageFile, Map<String, String> data) {
    return _netUtil
        .uploadFile(
            httpMethod, url, imageFile, uploadKey, basicHeaders, data, utf8)
        .then((StreamedResponse data) {
      print("STATUS: ${data.statusCode} DATA: $data");
      return data;
    });
  }
}
