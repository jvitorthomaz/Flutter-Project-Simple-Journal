import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

import 'http_interceptors.dart';

class WebClient{
  static const String url = "http://192.168.1.184:3000/"; 
  // "http://192.168.1.184:3000/"; //"http://192.168.0.2:3000/"; "http://192.168.0.3:3000/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()], 
    requestTimeout: const Duration(seconds: 5)
  );
}