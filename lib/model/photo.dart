import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'photo.g.dart';

@JsonSerializable()
class Photo{
  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  Photo({@required this.albumId, @required this.id, @required this.title, @required this.url, @required this.thumbnailUrl});

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}