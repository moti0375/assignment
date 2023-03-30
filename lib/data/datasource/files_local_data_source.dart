import 'dart:convert';
import 'dart:io';

import 'package:moti_assignment/data/datasource/local_data_source.dart';
import 'package:moti_assignment/model/photo.dart';
import 'package:path_provider/path_provider.dart';

class FilesLocalDataSource implements LocalDataSource {
  final String _fileName = "local_cache.json";

  @override
  Future savePhotos(List<Photo> items) async {
    print("Saving to local storage file");
    return await _writeTofile(items.map((e) => Map<String, dynamic>.from(e.toJson())).toList());
  }

  @override
  Future<List<Photo>> getPhotos() async {
    print("LocalDataSource: getPhotos ");
    String path = await _docPath();
    File file = File("$path/$_fileName");
    if (await file.exists()) {
      String content = await file.readAsString();
      return (json.decode(content) as List).map((i) => Photo.fromJson(i)).toList();
    }
    return [];
  }

  @override
  Future<void> removePhoto(Photo photo) async {

    List<Map<String, dynamic>> photos = await _getPhotosFromFile();
    Map<String, dynamic> ph = photos.firstWhere((element) => element['id'] == photo.id);
    int pIndex = photos.indexOf(ph);
    photos.removeAt(pIndex);
    await _writeTofile(photos);
    return;
  }

  @override
  Future<void> updatePhoto(Photo photo) async {
    print("updatePhoto about to update photo: $photo");

    List<Map<String, dynamic>> photos = await _getPhotosFromFile();
    Map<String, dynamic> ph = photos.firstWhere((element) => element['id'] == photo.id);
    int pIndex = photos.indexOf(ph);
    photos[pIndex] = photo.toJson();
    await _writeTofile(photos);
    return;
  }

  Future<List<Map<String, dynamic>>> _getPhotosFromFile() async {
    String path = await _docPath();
    File file = File("$path/$_fileName");
    String content = await file.readAsString();
    List<Map<String, dynamic>> list = (json.decode(content) as List).map((e) => Map<String,dynamic>.of(e)).toList();
    return list;
  }

  Future<void> _writeTofile(List<Map<String, dynamic>> list) async {
    String path = await _docPath();
    File file = File("$path/$_fileName");

    if (await file.exists() == false) {
      await file.create();
    }

    await file.writeAsString(jsonEncode(list));
    return;
  }

  Future<String> _docPath() async {
    Directory directory = await getApplicationSupportDirectory();
    String docPath = directory.path;
    return docPath;
  }
}
