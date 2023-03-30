import 'package:http/http.dart' as http;

class HttpClient{

  Future<dynamic> fetchData() {
     return http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
  }

}