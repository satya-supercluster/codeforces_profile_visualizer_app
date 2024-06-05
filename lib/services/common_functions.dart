import 'dart:convert';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>> fetchUserInfo(String username) async {
  final response = await http.get(Uri.parse('https://codeforces.com/api/user.info?handles=$username'));
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      return data['result'][0];
    } else {
      throw data['comment'].toString();
    }
}