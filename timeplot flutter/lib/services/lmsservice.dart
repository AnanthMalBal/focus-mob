// import 'dart:convert';

import 'package:http/http.dart' as http;

class Services{
Future<dynamic> LmsService()async{
return  (await  http.get(Uri.parse ('http://192.168.10.129:3000/LMS',)));

}
}