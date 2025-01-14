import 'dart:convert';
import 'dart:io';
import 'package:sims/model/responce.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

import '../repository/helper.dart';

class Inventory {
  Future<ResponceModel> getallinventory() async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.allproductAPI}');
    final response = await http.post(url);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";
    print('result: $result');
    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> filterallinventory(String category) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.allproductAPI}');
    final response = await http.post(url, body: {
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

  Future<ResponceModel> getinventory(String branch) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.allproductAPI}');
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
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.allproductAPI}');
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

  Future<ResponceModel> searchinventory(String productname) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.allproductAPI}');
    final response = await http.post(url, body: {
      'productname': productname,
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

  Future<ResponceModel> getimage(String productid) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.getimageAPI}');
    final response = await http.post(url, body: {
      'productid': productid,
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

  Future<ResponceModel> save(
      String descriptions,
      String price,
      String category,
      String barcode,
      String cost,
      String selectedFile,
      String fullname,
      String employeeid) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.saveproduct}');
    final response = await http.post(url, body: {
      'description': descriptions,
      'price': price,
      'category': category,
      'barcode': barcode,
      'cost': cost,
      'productimage': selectedFile,
      'fullname': fullname,
      'employeeid': employeeid
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print('result $responseData');

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> getallimage() async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.allImage}');
    final response = await http.post(url);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    print('resulta: $result');
    return data;
  }

  Future<ResponceModel> getstocks(String productid) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.getstocks}');
    final response = await http.post(url, body: {
      'productid': productid,
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

  Future<ResponceModel> getitem(String productid, String branchids) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.inventoryitem}');
    final response = await http.post(url, body: {
      'productid': productid,
      'branch': branchids,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print('item results: $result');

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> additemstocks(String productdata) async {
    Map<String, dynamic> serverinfo = {};

    if (Platform.isWindows) {
      serverinfo = await Helper().readJsonToFile('server.json');
    }
    if (Platform.isAndroid) {
      serverinfo = await JsonToFileRead('server.json');
    }

    String host = serverinfo['domain'];
    final url = Uri.parse('$host${Config.ainventoryddstocks}');
    final response = await http.post(url, body: {
      'productdata': productdata,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}
