import 'package:http/http.dart' as http;

class HttpClient{

  Future<dynamic> fetchData() {
     return http.get("https://jsonplaceholder.typicode.com/photos");
  }

}