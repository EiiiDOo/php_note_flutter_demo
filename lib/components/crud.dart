import 'dart:convert';

import 'package:http/http.dart';

class Crud {
  getRequest(String url) async {
    try {
      Response response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error ${response.statusCode}');
      }
    } catch (e) {
      print('Error catch $e');
    }
  }

  Future<Map<String, dynamic>?> postRequest(String url, Map data) async {
    print('👉 postRequest called');
    print('   URL: $url');
    print('   Payload: $data');
    try {
      final uri = Uri.parse(url);
      print('   Parsed URI: $uri');
      final response = await post(uri, body: data);
      print('   HTTP status: ${response.statusCode}');
      print('   Response body: ${response.body}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        print('   JSON decoded: $decoded');
        return decoded;
      } else {
        print('❌ Error ${response.statusCode}: ${response.reasonPhrase}');
        return null;
      }
    } catch (e, stack) {
      print('❌ Exception caught: $e');
      print(stack);
      return null;
    }
  }
}
