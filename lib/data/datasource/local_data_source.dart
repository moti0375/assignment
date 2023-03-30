import 'package:moti_assignment/model/photo.dart';

abstract class LocalDataSource {
  Future<dynamic> savePhotos(List<Photo> items);
  Future<List<Photo>> getPhotos();
  Future<void> updatePhoto(Photo photo);
  Future<void> removePhoto(Photo photo);
}