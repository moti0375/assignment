import 'package:moti_assignment/bloc/base_cubit.dart';
import 'package:moti_assignment/bloc/base_state/base_bloc_state.dart';
import 'package:moti_assignment/data/app_repository.dart';
import 'package:moti_assignment/model/photo.dart';
import 'package:moti_assignment/pages/home_bloc_state/home_bloc_state.dart';

class HomePageCubit extends BaseCubit<HomeBlocState> {
  AppRepository _repository;

  HomePageCubit(this._repository) : super(BaseBlocState.init());
  void fetchPhotos({bool refresh = false, bool showLoading = true}) async {
    if(showLoading){
      emit(BaseBlocState.loading());
    }
    _repository.fetchPhotos(force: refresh).then((photos) {
      emit(BaseBlocState.next(HomeBlocState.photosLoaded(photos: photos)));
    }).catchError((error) {
      emit(BaseBlocState.error(error));
    });
  }

  void updatePhoto(Photo photo) async {
    _repository.updatePhoto(photo).then((_) => fetchPhotos(refresh: false, showLoading: true));
  }

  void deletePhoto(Photo photo) async {
    _repository.deletePhoto(photo).then((_) => fetchPhotos(refresh: false, showLoading: false));
  }
}