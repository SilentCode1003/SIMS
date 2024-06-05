import 'dart:convert';
import 'dart:io';

import 'package:sims/model/responce.dart';
import 'package:sims/repository/helper.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Branches {
  Future<ResponceModel> branches(String branchid) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];

    final url = Uri.parse('$host${Config.branchesAPI}');
    final response = await http.get(url);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(result);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> addbranch(
      String branchid,
      String branchname,
      String tin,
      String address,
      String logo,
      String createdby,
      String employeeid) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];

    final url = Uri.parse('$host${Config.addbranch}');
    final response = await http.post(url, body: {
      'branchid': branchid,
      'branchname': branchname,
      'tin': tin,
      'address': address,
      'logo': logo,
      'createdby': createdby,
      'employeeid': employeeid
    });

    // print(
    //     '$fullname, $positionname, $contactinfo, $datehired, $createdby, $employeeid,');

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> editbranch(String branchid, String branchname,
      String tin, String address, String logo, String employeeid) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];

    final url = Uri.parse('$host${Config.editbranch}');
    final response = await http.post(url, body: {
      'branchid': branchid,
      'branchname': branchname,
      'tin': tin,
      'address': address,
      'logo': logo,
      'employeeid': employeeid
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print('status: $status');
    print('message: $message');
    print('result: $result');
    print('responseData: $responseData');
    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}
