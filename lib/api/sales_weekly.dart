import 'dart:convert';

import 'package:sims/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Week {
  Future<ResponceModel> allweeklysales(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.allweeklysales}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> byweeklysales(String daterange, String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.allweeklysales}');
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

  Future<ResponceModel> allweeklygraph(String daterange) async {
    final url = Uri.parse('${Config.apiUrl}${Config.weeklygraph}');
    final response = await http.post(url, body: {'daterange': daterange});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);

    return data;
  }

  Future<ResponceModel> byweeklygraph(String daterange, String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.weeklygraph}');
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
}
