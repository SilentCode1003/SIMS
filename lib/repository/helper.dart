import 'dart:convert';

import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum APIStatus { success, error }

enum Logtype { clockin, clockout }

class Helper {
  String GetCurrentDatetime() {
    DateTime currentDateTime = DateTime.now();
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(currentDateTime);
    return formattedDateTime;
  }

  String GetYesterdayDatetime() {
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(yesterday);
    return formattedDateTime;
  }

  Future<Map<String, dynamic>> readJsonToFile(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filePath');

    if (!file.existsSync()) {
      print('File does not exist.');
    }
    String jsonString = await file.readAsString();

    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    return jsonData;
  }

  Future<String> readFileContent(String filePath) async {
    try {
      File file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      print('Error reading file: $e');
      return '';
    }
  }

  String formatAsCurrency(double value) {
    return toCurrencyString(value.toString());
  }

  Future<void> deleteFile(String filepath) async {
    try {
      File file = File(filepath);

      if (await file.exists()) {
        await file.delete();
      } else {
        print('File not found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> writeJsonToFile(
      Map<String, dynamic> jsnonData, String filePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filePath');

      String jsonString = jsonEncode(jsnonData);

      await file.writeAsString(jsonString);
    } catch (e) {
      print(e);
    }
  }

  Future<void> writeJsonToFile1(List jsonListData, String filePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filePath');

      String jsonString = jsonEncode(jsonListData);

      await file.writeAsString(jsonString);
    } catch (e) {
      print(e);
    }
  }

  String getStatusString(APIStatus status) {
    switch (status) {
      case APIStatus.success:
        return 'success';
      case APIStatus.error:
        return 'error';
      default:
        return "";
    }
  }

  String getLogtype(Logtype type) {
    switch (type) {
      case Logtype.clockin:
        return 'ClockIn';
      case Logtype.clockout:
        return 'ClockOut';
      default:
        return "";
    }
  }

  String GetCurrentDate() {
    DateTime currentDateTime = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd').format(currentDateTime);
    return formattedDateTime;
  }
}

Future<String> getDownloadDir() async {
  try {
    Directory? downloadsDirectory = await getExternalStorageDirectory();
    String finalpath = downloadsDirectory!.path;
    String removepath = '/Android/data/com.example.eportal/files';
    String cleanPath = finalpath.replaceAll(removepath, '');
    print('Downloads directory: $cleanPath');
    return cleanPath;
  } catch (e) {
    print('Error getting downloads directory: $e');
    return '';
  }
}

Future<void> JsonToFileWrite(
    Map<String, dynamic> jsonData, String filename) async {
  try {
    // Get the app's documents directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';

    // Write JSON data to file
    final file = File(filePath);

    await file.writeAsString(json.encode(jsonData));

    print('JSON data written to: $filePath');
  } catch (e) {
    print('Error writing JSON data: $e');
  }
}

Future<Map<String, dynamic>> JsonToFileRead(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$filename';
  final file = File(filePath);

  print('JSON data read to: $filePath');

  // Check if the file exists
  if (!file.existsSync()) {
    print('File does not exist.');
  }

  // Read the contents of the file
  String jsonString = await file.readAsString();
  print(jsonString);

  // Parse the JSON string into a Map
  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  return jsonData;
}
