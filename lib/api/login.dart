import 'dart:convert';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Login {
  Future<ResponceModel> login(String username, String password) async {
    final url = Uri.parse('${Config.apiUrl}${Config.loginAPI}');
    final response = await http.post(url, body: {
      'username': username,
      'password': password,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(message);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> changepass(
      String currentpassword, String newpassword, usercode, employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.changepass}');
    final response = await http.post(url, body: {
      'currentpassword': currentpassword,
      'newpassword': newpassword,
      'usercode': usercode,
      'employeeid': employeeid
    });

    print('currentpassword: $currentpassword');
    print('newpassword: $newpassword');
    print('usercode: $usercode');
    print('employeeid: $employeeid');
    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(status);
    print(message);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}
