import 'dart:convert';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Catergory {
  Future<ResponceModel> categories() async {
    final url = Uri.parse('${Config.apiUrl}${Config.categoryAPI}');
    final response = await http.get(url);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> savecategory(
      String categoryname, String fullname, String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.addcategory}');
    final response = await http.post(url, body: {
      'categoryname': categoryname,
      'fullname': fullname,
      'employeeid': employeeid
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print('result $message');

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> editcategory(
      String categoryname, String categorycode, String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.editcategory}');
    final response = await http.post(url, body: {
      'categoryname': categoryname,
      'categorycode': categorycode,
      'employeeid': employeeid
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print('result $message');

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}
