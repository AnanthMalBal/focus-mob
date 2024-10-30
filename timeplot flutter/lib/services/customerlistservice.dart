
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timeplot_flutter/screens/appbar.dart';

class CustomerListService {
  Future getPhonenumberList(String text,context) async {
    print("customerphonenumbr"+text);
    final response = (await http
        .get(Uri.parse('http://192.168.31.45:3007/customer/customerlist?SearchText='+text)));
    Map<String, dynamic> dataPhoneList = json.decode(response.body.toString());   
    //  Map<String, dynamic> data = jsonDecode(response.body); 
    print("customerphonenumbr" +  dataPhoneList.toString());
    return  dataPhoneList;
  }


Future<dynamic> getList( context, {required int page, required int pageSize}) async {
  print("Fetching List");
  
  final response = await http.post(
    Uri.parse("http://192.168.31.45:3007/ticket/GetAllProductList"),
  );
  
  var result = json.decode(response.body);  // Decoding the response as a Map
  print("Response: " + result.toString());

  if (response.statusCode == 200) {
    showdialog(context, "List");
  }

  return result;  // Return the entire Map
}
}