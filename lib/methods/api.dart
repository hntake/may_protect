import 'dart:convert';

import 'package:may_protect/helper/constant.dart';
import 'package:http/http.dart' as http;

class API {
  postRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String url = apiUrl + route;
    try {
      return await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: _header(),
      );
    } catch (e) {
      print(e.toString());
      return jsonEncode(e);
    }
  }

  putRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String url = apiUrl + route;

    final response = await http.put(Uri.parse(url), body: data);
  }


  updateData({required String route, required Map<String, String> data}) async {
    final response = await http.put(Uri.parse(route), body: jsonEncode(data));
  }

  _header() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
}