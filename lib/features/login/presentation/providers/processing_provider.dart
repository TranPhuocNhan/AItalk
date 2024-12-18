import 'package:flutter/material.dart';

class ProcessingProvider with ChangeNotifier{
  bool _isLoading = false;
  void UpdateLoadingProcess(){
    _isLoading = !_isLoading;
    notifyListeners();
  }
  bool getProcessState(){ return _isLoading;}
}