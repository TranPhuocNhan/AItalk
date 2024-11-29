// import 'dart:convert';
// import 'package:flutter_ai_app/core/models/user.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   final String apiLink;

//   AuthService({required String this.apiLink});

//   Future<User> signUpAccount(
//       String email, String password, String username) async {
//     print("in signup account function");
//     final response = await http.post(
//       Uri.parse("${apiLink}/api/v1/auth/sign-up"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'email': email,
//         'password': password,
//         'username': username,
//       }),
//     );
//     if (response.statusCode == 201) {
//       var user = User.fromSignupJson(jsonDecode(response.body));
//       return user;
//     } else {
//       var issue = handleResponse(response.body);
//       throw Exception(issue);
//     }
//   }

//   Future<bool> signInAccount(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("${apiLink}/api/v1/auth/sign-in"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'email': email,
//         'password': password,
//       }),
//     );
//     if (response.statusCode == 200) {
//       var json = jsonDecode(response.body);
//       if (json.containsKey('token')) {
//         var token = json['token'];
//         await saveAccessToken(token['accessToken'], token['refreshToken']);
//         await getCurrentUser();
//         return true;
//       } else
//         return false;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> getCurrentUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? accessToken = "";
//     accessToken = await prefs.getString("accessToken");
//     final response = await http.get(
//       Uri.parse("${apiLink}/api/v1/auth/me"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer ${accessToken}',
//       },
//     );
//     if (response.statusCode == 200) {
//       var json = jsonDecode(response.body);
//       var username = json['username'];
//       var email = json['email'];
//       var id = json['id'];
//       await prefs.setString("currentUser", username);
//       await prefs.setString("currentEmail", email);
//       await prefs.setString("currentId", id);
//       return true;
//     } else
//       return false;
//   }

//   //FAILED
//   Future<bool> logoutAccount() async {
//     final prefs = await SharedPreferences.getInstance();
//     var refreshToken = await prefs.getString("refreshToken");
//     final response = await http.get(
//       Uri.parse("${apiLink}/api/v1/auth/sign-out"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $refreshToken',
//       },
//     );
//     if (response.statusCode == 200) {
//       print("STATUS CODE IS 200");
//       resetPreferences();
//       return true;
//     } else {
//       print("=== ERROR === ${response.body}");
//       print("Failed to logout!!!");
//       return false;
//     }
//   }

//   Future<void> checkSavedInformation() async {
//     final prefs = await SharedPreferences.getInstance();
//     var username = await prefs.getString("currentUser");
//     var email = await prefs.getString("currentEmail");
//     var id = await prefs.getString("currentId");
//     var accessToken = await prefs.getString("accessToken");
//     var refreshToken = await prefs.getString("refreshToken");
//     print("USERNAME -- ${username}");
//     print("EMAIL -- ${email}");
//     print("ID -- ${id}");
//     print("ACCESS TOKEN -- ${accessToken}");
//     print("REFRESH TOKEN -- ${refreshToken}");
//   }

//   Future<void> resetPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove("currentEmail");
//     await prefs.remove("currentUser");
//     await prefs.remove("currentId");
//     await prefs.remove("accessToken");
//     await prefs.remove("refreshToken");
//   }

//   Future<void> saveAccessToken(String accessToken, String freshToken) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("accessToken", accessToken);
//     await prefs.setString("refreshToken", freshToken);
//   }

//   String handleResponse(String response) {
//     final Map<String, dynamic> decodeResponse = jsonDecode(response);
//     if (decodeResponse.containsKey("details") &&
//         decodeResponse['details'] is List &&
//         !decodeResponse['details'].isEmpty) {
//       String issue = decodeResponse['details'][0]['issue'];
//       return issue;
//     } else
//       return "";
//   }
// }
