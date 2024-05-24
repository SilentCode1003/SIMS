import 'dart:convert';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Dashboard {
  Future<ResponceModel> allyearsales(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.yearsales}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.yearsales}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.yeargraph}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.yeargraph}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.yeartopseller}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.yeartopseller}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.topemployee}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.topemployee}');
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
