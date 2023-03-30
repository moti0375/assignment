import 'dart:convert';
import 'dart:io';

import 'package:moti_assignment/data/datasource/local_data_source.dart';
import 'package:moti_assignment/model/photo.dart';
import 'package:path_provider/path_provider.dart';

class FilesLocalDataSource implements LocalDataSource {
  final String _fileName = "local_cache.json";

  List<Photo> _localCache = [];

  @override
  Future savePhotos(List<Photo> items) async {
    print("Saving to local storage file");
    String path = await _docPath();

    File file = File("$path/$_fileName");

    if (await file.exists() == false) {
      await file.create();
    }
    print("savePhotos: ${file.path}");
    return await file.writeAsString(jsonEncode(items));
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

    List<Map<String, dynamic>> list = await _getPhotosFromFile();

    print("temp: ${list}");
    Map<String, dynamic> p = list.firstWhere((element) => element['id'] == photo.id);
    int pIndex = list.indexOf(p);
    list.removeAt(pIndex);
    await _writeTofile(list);
    return;
  }

  @override
  Future<void> updatePhoto(Photo photo) async {
    print("updatePhoto about to update photo: $photo");

    List<Map<String, dynamic>> list = await _getPhotosFromFile();
    print("temp: ${list}");
    Map<String, dynamic> p = list.firstWhere((element) => element['id'] == photo.id);
    int pIndex = list.indexOf(p);
    print("updatePhoto: item to replace $p, index: $pIndex");

    list[pIndex] = photo.toJson();

    print("Updated photo: ${list[2]["title"]}");
    //Photo p = photos.firstWhere((element) => element.id == photo.id);
    await _writeTofile(list);
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
    await file.writeAsString(jsonEncode(list));
    return;
  }

  Future<String> _docPath() async {
    Directory directory = await getApplicationSupportDirectory();
    String docPath = directory.path;
    print("_docPath: $docPath");
    return docPath;
  }
}
