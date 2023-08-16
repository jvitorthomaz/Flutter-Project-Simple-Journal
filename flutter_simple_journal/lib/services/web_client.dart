import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

import 'http_interceptors.dart';

class WebClient{
  static const String url = "Seu_endereço_IP_como_string"; 

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()], 
    requestTimeout: const Duration(seconds: 5)
  );
}
