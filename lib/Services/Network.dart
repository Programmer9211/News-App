import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  final String _url =
      "http://newsapi.org/v2/everything?q=tesla&from=2020-12-29&sortBy=publishedAt&apiKey=8ec588cc35214f56a291d99025b7eeff";

  Future<List> getNewsFeed(String url) async {
    Map<String, dynamic> _map = {};

    List list = List();

    try {
      var response = await http.get(url == null ? _url : url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _map = json.decode(response.body);

        list = _map['articles'];

        print(_map['articles']);
        return list;
      } else {
        print("Error_______________________________________");
        return List();
      }
    } catch (e) {
      print("Error : $e ");
      return List();
    }
  }
}
