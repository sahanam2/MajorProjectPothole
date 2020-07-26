// import 'dart:collection';

// import 'package:flutter/cupertino.dart';
// import 'package:potholedetection/model/locimage.dart';

// class LocNotifier with ChangeNotifier {
//   List<LocModel> _locList = [];
//   LocModel _currentLoc;

//   UnmodifiableListView<LocModel> get locList => UnmodifiableListView(_locList);

//   LocModel get currentLoc => _currentLoc;

//   set locList(List<LocModel> locList) {
//     _locList = locList;
//     notifyListeners();
//   }

//   set currentLoc(LocModel loc) {
//     _currentLoc = loc;
//     notifyListeners();
//   }

//   addFood(LocModel loc) {
//     _locList.insert(0, loc);
//     notifyListeners();
//   }

//   deleteFood(LocModel loc) {
//     _locList.removeWhere((_loc) => _loc.id == loc.id);
//     notifyListeners();
//   }
// }
