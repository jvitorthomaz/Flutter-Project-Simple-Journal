import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class JournalService {
  static const String url = "http://192.168.0.3:3000/";
  static const String resource = "leanhttp/";

  http.Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  getUrl(){
    return "$url$resource";
  }

  register(String content){
    client.post(Uri.parse(getUrl()), body:{
      "content": content
    });
  }

  Future<String> get() async{
    http.Response response = await client.get(Uri.parse(getUrl()));
    print(response.body);
    return response.body;
  }

}
