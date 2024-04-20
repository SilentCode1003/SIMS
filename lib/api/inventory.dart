import 'dart:convert';
import 'package:sims/model/responce.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

class Inventory {
  Future<ResponceModel> getinventory(String branch) async {
    final url = Uri.parse('${Config.apiUrl}${Config.inventoryAPI}');
    final response = await http.post(url, body: {
      'branch': branch,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print('result $result');

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> filterinventory(String branch, String category) async {
    final url = Uri.parse('${Config.apiUrl}${Config.filterAPI}');
    final response = await http.post(url, body: {
      'branch': branch,
      'category': category,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print('result $result');

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}
