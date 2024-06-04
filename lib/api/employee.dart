import 'dart:convert';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Employees {
  Future<ResponceModel> employee() async {
    final url = Uri.parse('${Config.apiUrl}${Config.employeelist}');
    final response = await http.post(url);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> getemployee(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.employeelist}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> addemployee(
      String fullname,
      String positionname,
      String contactinfo,
      String datehired,
      String createdby,
      String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.addemployee}');
    final response = await http.post(url, body: {
      'fullname': fullname,
      'positionname': positionname,
      'contactinfo': contactinfo,
      'datehired': datehired,
      'createdby': createdby,
      'employeeid': employeeid
    });

    print(
        '$fullname, $positionname, $contactinfo, $datehired, $createdby, $employeeid,');

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> editemployee(
    String employeeid,
    String positionname,
    String contactinfo,
    String fullname,
  ) async {
    final url = Uri.parse('${Config.apiUrl}${Config.editemployee}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
      'positionname': positionname,
      'contactinfo': contactinfo,
      'fullname': fullname,
    });

    print('$fullname, $positionname, $contactinfo, $employeeid,');

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> position() async {
    final url = Uri.parse('${Config.apiUrl}${Config.loadposition}');
    final response = await http.get(url);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";
    print(result);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}
