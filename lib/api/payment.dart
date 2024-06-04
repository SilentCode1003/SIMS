import 'dart:convert';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Payment {
  Future<ResponceModel> paymnet() async {
    final url = Uri.parse('${Config.apiUrl}${Config.paymentlsit}');
    final response = await http.get(url);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> savepayment(
      String paymentname, String fullname, String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.addpayment}');
    final response = await http.post(url, body: {
      'paymentname': paymentname,
      'fullname': fullname,
      'employeeid': employeeid,
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

  Future<ResponceModel> editpayment(
      String paymentname, String paymentcode, String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.editpayment}');
    final response = await http.post(url, body: {
      'paymentname': paymentname,
      'paymentcode': paymentcode,
      'employeeid': employeeid,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print('result $status');

    return ResponceModel(message, status, result, description);
  }
}
