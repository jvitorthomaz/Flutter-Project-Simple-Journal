import 'dart:convert';

import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

import '../models/journal_model.dart';

class JournalService {
  static const String url = "http://192.168.0.2:3000/"; //"http://192.168.1.184:3000/"; "http://192.168.0.3:3000/";
  static const String resource = "journals/";

  http.Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  getUrl(){
    return "$url$resource";
  }

  Future<bool> register(Journal journal) async{
    String jsonJournal = json.encode(journal.toMap()); 
    http.Response response = await client.post(
      Uri.parse(getUrl()), 
      headers: {
        'Content-type' : 'application/json'
      },
      body: jsonJournal
    );



    if (response.statusCode == 201) {
      return true;

    } else{
     // print(response.statusCode);
      return false;
    }
  }

  Future<List<Journal>> getAll() async{
    http.Response response = await client.get(Uri.parse(getUrl()));
    if (response.statusCode != 200) {
      throw Exception();
    }
    List<Journal> list = [];

    List<dynamic> listOfJournals = json.decode(response.body);

    for(var jsonMap in listOfJournals) {
      list.add(Journal.fromMap(jsonMap));
    }

    //print(list.length);

    return list;
  }

  Future<String> get() async{
    http.Response response = await client.get(Uri.parse(getUrl()));
    //print(response.body);
    return response.body;
  }

}
