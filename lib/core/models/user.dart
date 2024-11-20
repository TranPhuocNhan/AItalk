import 'package:injectable/injectable.dart';
@injectable
class User{
  final String id;
  final String email;
  final String username;
  @singleton
  User({
    required this.id,
    required this.email,
    required this.username,
  });
  factory User.fromSignupJson(Map<String, dynamic> json){
    if(json.containsKey('user')){
      var user = json['user'];
      String email = user['email'];
      String id = user['id'];
      String username = user['username'];
      return User( 
        id: id,
        email: email,
        username: username,
      );
    }else 
    return User(id: "", email: "", username: "");
  }
  // factory User.fromLoginJson(Map<String, dynamic> json){

  // }
}