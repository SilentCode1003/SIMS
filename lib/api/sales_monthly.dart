import 'dart:convert';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class MontlySales {
  Future<ResponceModel> allmonthsales(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.allmonthsales}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    return data;
  }

  Future<ResponceModel> bymonthsales(String daterange, String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.allmonthsales}');
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

  Future<ResponceModel> allmonthgraph(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.monthlygraph}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> bymonthlygraph(String daterange, String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.monthlygraph}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.monthlytopseller}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.monthlytopseller}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.monthlyitem}');
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
    final url = Uri.parse('${Config.apiUrl}${Config.monthlyitem}');
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

  Future<ResponceModel> monthemployee(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.monthemployeesales}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    print('result na to: $result');
    print('date na tos $daterange');

    return data;
  }

  Future<ResponceModel> monthbyemployee(String daterange, String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.monthemployeesales}');
    final response =
        await http.post(url, body: {'daterange': daterange, 'branch': branch});

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
