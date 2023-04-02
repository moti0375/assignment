import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moti_assignment/model/photo.dart';
part 'home_bloc_state.freezed.dart';

@freezed
class HomeBlocState with _$HomeBlocState{
  const factory HomeBlocState.photosLoaded({required List<Photo> photos}) = _PhotosLoaded;

}