import 'dart:convert';

import 'package:http/http.dart'as http;

class RequestAssistant{
  static Future<dynamic> getReguest(String url) async{
    try{
      var Linkuri = Uri.parse(url);

      http.Response response = await http.get(Linkuri);
      if(response.statusCode ==200){
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
      return decodeData;
      }
      else{
        return "Failed";
      }
    }
    catch(exp){
      return "failed";
    }
  }
}