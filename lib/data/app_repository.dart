import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:moti_assignment/model/api_response.dart';
import 'package:moti_assignment/network/http_client.dart';

import '../model/photo.dart';
abstract class AppRepository{
  Future<List<Photo>> fetchPhotos();
}


class AppRepositoryImpl implements AppRepository{

  HttpClient _client;

  AppRepositoryImpl(this._client);

  @override
  Future<List<Photo>> fetchPhotos() async {

    print("fetching photos");
    Response response = await _client.fetchData();

    if(response.body != null){
      List<Photo> photos = (json.decode(response.body) as List).map((i) => Photo.fromJson(i)).toList();
      print("photos: $photos");
      return Future.value(photos);
    } else {
      return [];
    }
  }


}