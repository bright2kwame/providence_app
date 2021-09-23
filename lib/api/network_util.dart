import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  static const noInternetConnection =
      "It appears you are offline, connect and try again.";
  static const serverError =
      "Ooops something went wrong trying to make your request. We will look into it shortly";
  static const missingError =
      "Ooops the resource you are requesting for was not found.";

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  //MARK: manage all get calls
  Future<dynamic> get(String url, Map<String, String> headers, encoding) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw new Exception(noInternetConnection);
    }
    final response = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(response);
  }

  //MARK: manage all get calls without headers
  Future<dynamic> getNoHeaders(String url, {body, encoding}) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw new Exception(noInternetConnection);
    }
    final response = await http.get(Uri.parse(url));
    return handleResponse(response);
  }

  //MARK: manage all post calls
  Future<dynamic> post(
      String url, Map<String, String> headers, body, encoding) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw new Exception(noInternetConnection);
    }
    final response = await http.post(Uri.parse(url),
        body: body, headers: headers, encoding: encoding);
    return handleResponse(response);
  }

  //MARK: manage all delete calls
  Future<dynamic> delete(String url, Map<String, String> headers) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return noInternetConnection;
    }
    final response = await http.delete(Uri.parse(url), headers: headers);
    return handleResponse(response);
  }

  //MARK: manage all put calls
  Future<dynamic> put(
      String url, Map<String, String> headers, body, encoding) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw new Exception(noInternetConnection);
    }
    final response = await http.put(Uri.parse(url),
        body: body, headers: headers, encoding: encoding);
    return handleResponse(response);
  }

  //MARK: handle the file upload
  Future<http.StreamedResponse> uploadFile(
      String httpMethod,
      String url,
      File imageFile,
      String uploadKey,
      Map<String, String> headers,
      Map body,
      encoding) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception(noInternetConnection);
    }

    var stream = new http.ByteStream(
      DelegatingStream.typed(imageFile.openRead()),
    );
    var length = await imageFile.length();
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest(httpMethod, uri);
    body.forEach((key, value) {
      request.fields[key] = value;
    });
    var multipartFile = new http.MultipartFile("$uploadKey", stream, length,
        filename: basename(imageFile.path));
    request.headers.addAll(headers);
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      return response;
    } else if (statusCode >= 401 && statusCode <= 499) {
      throw new Exception(missingError);
    } else if (statusCode >= 500 && statusCode <= 600) {
      throw new Exception(serverError);
    } else {
      throw new Exception("Error while connecting to server.");
    }
  }

  //MARK: handle response
  Future<dynamic> handleResponse(http.Response response) async {
    final int statusCode = response.statusCode;
    print("API STATUS: $statusCode DATA: ${response.body}");
    if (statusCode < 200) {
      throw new Exception("Error while connecting to server.");
    } else if (statusCode >= 401 && statusCode <= 404) {
      throw new Exception("Invalid token header. No credentials provided.");
    } else if (statusCode >= 404 && statusCode <= 499) {
      throw new Exception(missingError);
    } else if (statusCode >= 500 && statusCode <= 600) {
      throw new Exception(serverError);
    }
    return json.decode(response.body);
  }
}
