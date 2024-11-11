import 'package:flutter_ai_app/core/di/module/api_service_module.dart';

class ServiceInjection {
  // final getIt = GetIt.instance; 
  static Future<void> ConfigureServiceInjection() async{
    await ApiServiceModule.configureAuthenticationModuleInjection();
  } 
}