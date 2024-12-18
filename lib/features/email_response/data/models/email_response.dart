import 'package:injectable/injectable.dart';
@injectable 
class EmailResponse{
  final String email;
  final int remainUsage;
  EmailResponse({
    required this.email,
    required this.remainUsage,
  });
  factory EmailResponse.fromReponseJson(Map<String, dynamic> json){
    if(json.containsKey('email')){
      var email = json['email'];
      var remain = int.parse(json['remainingUsage'].toString());
      return EmailResponse(
        email: email, 
        remainUsage: remain,
      );
    }else{
      return EmailResponse(email: "", remainUsage: -1);
    }
  }

}