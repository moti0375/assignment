import 'dart:convert';

import 'package:http/http.dart';
import 'package:moti_assignment/model/photo.dart';
import 'package:moti_assignment/network/http_client.dart';

abstract class RemoteDataSource{
  Future<List<Photo>> fetchPhotos();
  Future<dynamic> deletePhoto(int id);
  Future<dynamic> updatePhoto(Photo photo);
}

class PhotosRemoteDataSource implements RemoteDataSource{

  final HttpClient _client;

  PhotosRemoteDataSource(this._client);

  @override
  Future deletePhoto(int id) {
    return Future.value(null);
  }

  @override
  Future<List<Photo>> fetchPhotos() async {
    Response response = await _client.fetchData();
    List<Photo> photos = (json.decode(response.body) as List).map((i) => Photo.fromJson(i)).toList();
    print("photos: $photos");
    return Future.value(photos);
  }

  @override
  Future updatePhoto(Photo photo) {
    return Future.value(null);
  }


}