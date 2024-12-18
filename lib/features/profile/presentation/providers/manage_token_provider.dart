import 'package:flutter/material.dart';

class Managetokenprovider with ChangeNotifier{
  bool _isUnlimited = false;
  int _totalTokens = 0;
  int _available = 0;
  double percentage = 0.0;
  void updateRemainToken(int value){
    updateRemainTokenWithoutNotify(value);
    notifyListeners();
  }
  void updateRemainTokenWithoutNotify(int value){
    _available = value;
  }
  void updateTotalToken(int value){
    _totalTokens = value;
    notifyListeners();
  }
  void setIsUnlimited(){
    _isUnlimited = !_isUnlimited;
    notifyListeners();
  }
  void updatePercentage(){
    updatePercentageWithoutNotify();
    notifyListeners();
  }

  void updatePercentageWithoutNotify(){
    if(_totalTokens == 0 || _available == 0 ) {
      percentage = 0;
    }
    else {
      percentage = (_available.toDouble() / _totalTokens.toDouble());
    }
  }

  
  int getRemainToken(){return _available;}
  int getTotalToken(){return _totalTokens;}  
  int getPercentage(){
    if(_totalTokens == 0 || _available == 0 ) {
      return 0;
    }
    else {
      var percent = (_available.toDouble() / _totalTokens.toDouble()).toInt();
      return percent;
    }
  }
  bool getIsUnlimited(){return _isUnlimited;}

  void decreateRemaining(){
    _available -= 1;
    notifyListeners();
  }



}