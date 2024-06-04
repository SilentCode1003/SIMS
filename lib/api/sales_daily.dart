import 'dart:convert';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class DailySales {
  Future<ResponceModel> alldailysales(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.alldaysales}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> bydailyssales(String daterange, String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.alldaysales}');
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

  Future<ResponceModel> alldailygraph(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.dailygraph}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    print('result: $result');
    return data;
  }

  Future<ResponceModel> bydailygraph(String daterange, String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.dailygraph}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.weeklytopseller}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.weeklytopseller}');
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

  Future<ResponceModel> allitem(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.item}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    return data;
  }

  Future<ResponceModel> byitem(String daterange, String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.item}');
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

  Future<ResponceModel> dailyemployee(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.dailyemployeesales}');
    final response = await http.post(url, body: {'date': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    print('result na to: $result');
    print('date na to $daterange');

    return data;
  }

  Future<ResponceModel> dailybyemployee(String daterange, String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.dailyemployeesales}');
    final response =
        await http.post(url, body: {'date': daterange, 'branch': branch});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    print('result na to: $result');
    print('date na to $daterange');

    return data;
  }
}
