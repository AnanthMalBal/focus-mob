import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';


final shareddata = SharedPref();

SharedPreferences? prefs;

class MenuService {
 

//   Future<List<Map<String, dynamic>>> fetchMenuItems(
//       String token, String roles,  ) async {
//     print("tokenroles:" + token + roles);

//     final String menuUrl = dotenv.env['menulistUrl']!;
//     print("url" + menuUrl);

//     final headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': '$token',
//     };

//     print("::Headers:: " + headers.toString());
//     Map<String, String> requestBody = {
//       'roles':roles,
//     };
//     print("body" + requestBody.toString());

//     final response = await http.post(
//       Uri.parse(menuUrl),
//       headers: headers,
//       body: jsonEncode(requestBody),
//     );
//     print('Response Status: ${response.statusCode}');
//     print('Response Body: ${response.body}');
//     if (response.statusCode == 200) {
//      List<dynamic> menuData = jsonDecode(response.body);

    
    
//       //  return menuData.map((menu) => Map<String, dynamic>.from(menu)).toList();
//        return buildMenuHierarchy(menuData);
      
      
//     } else {
//       throw Exception('Failed to load menu items');
//     }
//   }


// // Function to build the menu hierarchy from the raw data
//   List<Map<String, dynamic>> buildMenuHierarchy(List<dynamic> data) {
//     Map<String, Map<String, dynamic>> allMenus = {};
//     List<Map<String, dynamic>> rootMenus = [];

//     for (var item in data) {
//       // Convert the item to a Map
//       Map<String, dynamic> menu = Map<String, dynamic>.from(item);

//       // Store the menu item by its ID
//       allMenus[menu['menuId']] = menu;

//       // If it's a root menu (its parentId matches menuId), add it to the rootMenus list
//       if (menu['parentId'] == menu['menuId']) {
//         rootMenus.add(menu);
//       } else {
//         // If the menu has a parent, add it to the parent's submenu
//         allMenus[menu['parentId']]?['subMenu'] ??= [];
//         allMenus[menu['parentId']]?['subMenu'].add(menu);
//       }
//     }
// // Ensure that each menu item includes the 'menuName'
//     rootMenus.forEach((menu) {
//       print('Menu Name: ${menu['menuName']}');  // Debug print
//     });

    
//     return rootMenus;
//   }


Future<List<Map<String, dynamic>>> fetchMenuItems(String token, String roles) async {
  print("Fetching menu for roles: $roles with token: $token");

  final String menuUrl = dotenv.env['menulistUrl']!;
  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': '$token',
  };

  final Map<String, String> requestBody = {'roles': roles};

  try {
    final response = await http.post(
      Uri.parse(menuUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> menuData = jsonDecode(response.body);

      if (menuData.isEmpty) {
        print("❌ Warning: API returned an empty menu list!");
        return [];
      }

      // ✅ Process the menu hierarchy
      return buildMenuHierarchy(menuData);
    } else {
      throw Exception('Failed to load menu items. Status: ${response.statusCode}');
    }
  } catch (e) {
    print("❌ Error fetching menu items: $e");
    return []; // Return an empty list if an error occurs
  }
}

List<Map<String, dynamic>> buildMenuHierarchy(List<dynamic> data) {
  Map<String, Map<String, dynamic>> allMenus = {};
  List<Map<String, dynamic>> rootMenus = [];

  for (var item in data) {
    // Convert the item to a Map
    Map<String, dynamic> menu = Map<String, dynamic>.from(item);

    // Ensure the 'subMenu' field is always initialized
    menu['subMenu'] = [];

    // Store the menu item by its ID
    allMenus[menu['menuId']] = menu;
  }

  for (var item in data) {
    String parentId = item['parentId'];
    String menuId = item['menuId'];

    if (parentId == menuId) {
      // ✅ Add top-level menus to the root list
      rootMenus.add(allMenus[menuId]!);
    } else {
      // ✅ Attach submenus to their respective parents
      if (allMenus.containsKey(parentId)) {
        allMenus[parentId]!['subMenu'].add(allMenus[menuId]!);
      }
    }
  }

  // ✅ Debug print to check if menus & submenus are correctly formed
  for (var menu in rootMenus) {
    print('Menu Name: ${menu['menuName']} -> Submenus: ${menu['subMenu'].length}');
  }

  return rootMenus;
}

}

