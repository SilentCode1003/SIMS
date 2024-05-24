import 'dart:convert';
import 'package:sims/model/responce.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

class Inventory {
  Future<ResponceModel> getallinventory() async {
    final url = Uri.parse('${Config.apiUrl}${Config.allproductlist}');
    final response = await http.post(url);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> filterallinventory(String category) async {
    final url = Uri.parse('${Config.apiUrl}${Config.allproductlist}');
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

  Future<ResponceModel> getimage(String productid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.getimageAPI}');
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

  Future<ResponceModel> save(String descriptions, String price, String category,
      String barcode, String cost, String selectedFile, String fullname) async {
    final url = Uri.parse('${Config.apiUrl}${Config.saveproduct}');
    final response = await http.post(url, body: {
      'description': descriptions,
      'price': price,
      'category': category,
      'barcode': barcode,
      'cost': cost,
      'productimage': selectedFile,
      'fullname': fullname,
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

  Future<ResponceModel> getallimage() async {
    final url = Uri.parse('${Config.apiUrl}${Config.allImage}');
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
}
