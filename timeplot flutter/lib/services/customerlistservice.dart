
import 'dart:convert';
import 'package:http/http.dart' as http;

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
}