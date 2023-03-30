import 'package:moti_assignment/model/photo.dart';

abstract class LocalDatasource {
  List<Photo> getPhotos();
  void updatePhoto(Photo photo);
}