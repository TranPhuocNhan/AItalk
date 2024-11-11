
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class UserDataService {
  final String apiLink;
  UserDataService({required this.apiLink});

  Future<List<int>> getTokenUsage() async{
    var prefs = await SharedPreferences.getInstance();
    var refreshToken = await prefs.getString('refreshToken');
    var response = await http.get(
      Uri.parse("${apiLink}/api/v1/tokens/usage"),
      headers:  <String,String>{
        'Content-Type' : 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $refreshToken',
      },
    );
    if(response.statusCode == 200){
      var json = jsonDecode(response.body);
      var availableTokens = json['availableTokens'];
      var totalTokens = json['totalTokens'];
      List<int> output = [availableTokens, totalTokens];
      return output;
    }else{
      throw Exception("There are something wrong");
    }
  }
}