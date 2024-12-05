import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _menuItems = [];

  List<Map<String, dynamic>> get menuItems => _menuItems;

  void setMenuItems(List<Map<String, dynamic>> items) {
    _menuItems = items;
    notifyListeners();  // Notify listeners when menu items are updated
  }
}