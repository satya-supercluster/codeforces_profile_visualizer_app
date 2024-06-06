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
Future<List<Map<String, dynamic>>> fetchUserRating(String username) async {
  final response = await http.get(Uri.parse('https://codeforces.com/api/user.rating?handle=$username'));
  Map<String, dynamic> data = jsonDecode(response.body);
  if (data['status'] == 'OK') {
  List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(data['result']);
  return result;
  } else {
    throw data['comment'].toString();
  }
}
Future<List<Map<String, dynamic>>> fetchUserProblem(String username) async {
  final response = await http.get(Uri.parse('https://codeforces.com/api/user.status?handle=$username'));
  Map<String, dynamic> data = jsonDecode(response.body);
  if (data['status'] == 'OK') {
  List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(data['result']);
  return result;
  } else {
    throw data['comment'].toString();
  }
}