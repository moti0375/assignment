import 'package:flutter/cupertino.dart';
import 'package:moti_assignment/model/photo.dart';
import 'package:json_annotation/json_annotation.dart';
part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  List<Photo> photos;

  ApiResponse({required this.photos});


  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}