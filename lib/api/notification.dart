import 'dart:convert';
import 'dart:io';

import 'package:sims/model/responce.dart';
import 'package:sims/repository/helper.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Notifications {
  Future<ResponceModel> getnotification(String usercode) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.getnotification}');
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
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.readnotification}');
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
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.deletenotification}');
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
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.recievednotification}');
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
