import 'dart:convert';
import 'dart:io';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

import '../repository/helper.dart';

class Dashboard {
  Future<ResponceModel> allyearsales(String daterange) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.yearsales}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> byyearsales(String daterange, String branch) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.yearsales}');
    final response =
        await http.post(url, body: {'daterange': daterange, 'branch': branch});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> allyeargraph(String daterange) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.yeargraph}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    return data;
  }

  Future<ResponceModel> byyeargraph(String daterange, String branch) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.yeargraph}');
    final response =
        await http.post(url, body: {'daterange': daterange, 'branch': branch});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    return data;
  }

  Future<ResponceModel> alltopseller(String daterange) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.yeartopseller}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> bytopseller(String daterange, String branch) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.yeartopseller}');
    final response =
        await http.post(url, body: {'daterange': daterange, 'branch': branch});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    return data;
  }

  Future<ResponceModel> alltopemployee(String daterange) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.topemployee}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> bytopemployee(String daterange, String branch) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.topemployee}');
    final response =
        await http.post(url, body: {'daterange': daterange, 'branch': branch});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    return data;
  }
}
