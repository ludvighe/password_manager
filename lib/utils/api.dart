import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:password_manager/providers/password_data.dart';

class Api {
  static String url = 'http://10.0.2.2:8080';

  static Future<String> testApi() async {
    Response response = await http.get('$url/passworddata');

    return response.body;
  }

  static Future<List<dynamic>> getAllPasswordData(String key) async {
    try {
      Response response = await http.get('$url/passworddata/key=$key');
      return jsonDecode(response.body);
    } catch (e) {
      print('Could not get all password data');
      // throw Exception(['APIException', 'Could not get all password data']);
    }
  }

  static Future<void> postPasswordData(PasswordData passwordData, String key) async {
    try {
      // Gives id in response
      Response response = await http.post('$url/passworddata/key=$key',
          headers: <String, String>{'Content-Type': 'application/json'},
          body: passwordData.toJson());
      print(response.body);
      // return response.body;
    } catch (e) {
      throw Exception(['APIException', 'Could not post password data']);
    }
  }

  static Future<void> putPasswordData(PasswordData passwordData, String key) async {
    try {
      await http.put('$url/passworddata/${passwordData.id}/key=$key',
          headers: <String, String>{'Content-Type': 'application/json'},
          body: passwordData.toJson());
    } catch (e) {
      throw Exception(['APIException', 'Could not put password data']);
    }
  }

  static Future<void> deletePasswordData(String id, String key) async {
    try {
      await http.delete('$url/passworddata/$id/key=$key',
          headers: <String, String>{'Content-Type': 'application/json'});
    } catch (e) {
      throw Exception(['APIException', 'Could not delete password data']);
    }
  }
}
