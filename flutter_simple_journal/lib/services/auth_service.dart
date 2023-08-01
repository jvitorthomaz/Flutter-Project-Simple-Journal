import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_interceptors.dart';


class AuthService {

  static const String url = "http://192.168.1.184:3000/"; //"http://192.168.0.2:3000/"; "http://192.168.0.3:3000/";
  static const String resource = "journals/";

  http.Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> login({required String email, required String password}) async{
    http.Response response = await client.post(
      Uri.parse('${url}login'),
      body: {
        'email': email,
        'password': password,
      }
    );

    if(response.statusCode != 200){
      String content = json.decode(response.body);

      //throw HttpException(response.body);
      switch (content){
        case "Cannot find user":
        throw UserNotFoundException();
      }
      throw HttpException(response.body);
        
    }
    print('$email\n$password');
    await saveUserInfos(response.body);

    return true;
  }

  register({required String email, required String password}) async{
    http.Response response = await client.post(
      Uri.parse('${url}register'),
      body: {
        'email': email,
        'password': password,
      }
    );

    if (response.statusCode != 201) {
      throw HttpException(response.body);

    }

    await saveUserInfos(response.body);
    
  }

  saveUserInfos(String body) async{
    Map<String, dynamic> map = json.decode(body);

    String token = map["accessToken"] ?? "";
    String email = map["user"]["email"] ?? "";
    int id = map["user"]["id"] ?? 0;

    print("$token\n$email\n$id");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", token);
    prefs.setString("email", email);
    prefs.setInt("id", id);

    String? tokenSalvo = await prefs.getString("accessToken");
    print("=======================>$tokenSalvo");
  }
  
}

class UserNotFoundException implements Exception  {
  
}
