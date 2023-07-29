import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

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
        

    } else {

    }

    return true;
  }

  register({required String email, required String password}) async{
    http.Response response = await client.post(
      Uri.parse('${url}login'),
      body: {
        'email': email,
        'password': password,
      }
    );

  }
  
}

class UserNotFoundException implements Exception  {
  
}
