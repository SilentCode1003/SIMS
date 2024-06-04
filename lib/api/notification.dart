import 'dart:convert';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Notifications {
  Future<ResponceModel> getnotification(String usercode) async {
    final url = Uri.parse('${Config.apiUrl}${Config.getnotification}');
    final response = await http.post(url, body: {'usercode': usercode});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> readnotification(String notificationid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.readnotification}');
    final response =
        await http.post(url, body: {'notificationid': notificationid});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> deletenotification(String notificationid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.deletenotification}');
    final response =
        await http.post(url, body: {'notificationid': notificationid});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> recievednotification(String notificationid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.recievednotification}');
    final response =
        await http.post(url, body: {'notificationid': notificationid});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}
