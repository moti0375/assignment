import 'dart:async';
import 'package:moti_assignment/data/datasource/local_data_source.dart';
import 'package:moti_assignment/data/datasource/remote_data_source.dart';

import '../model/photo.dart';

abstract class AppRepository {
  Future<List<Photo>> fetchPhotos({bool force = false});
  Future<void> updatePhoto(Photo photo);
  Future<void> deletePhoto(Photo photo);
}

class AppRepositoryImpl implements AppRepository {
  RemoteDataSource _remoteDataSource;
  LocalDataSource _localDataSource;

  AppRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Photo>> fetchPhotos({bool force = false}) async {
    return _localDataSource.getPhotos().then((localPhotos) async {
      if (localPhotos.isEmpty || force) {
        print("AppRepository: fetchPhotos: localPhotos $localPhotos");
        return await _remoteDataSource.fetchPhotos().then((value) async => _localDataSource.savePhotos(value).then((value) => _localDataSource.getPhotos()));
      } else {
        return localPhotos;
      }
    });
  }

  @override
  Future<void> updatePhoto(Photo photo) {
    return _localDataSource.updatePhoto(photo);
  }

  @override
  Future<void> deletePhoto(Photo photo) {
    return _localDataSource.removePhoto(photo);
  }
}
