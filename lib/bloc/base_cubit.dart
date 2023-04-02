import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moti_assignment/bloc/base_state/base_bloc_state.dart';

abstract class BaseCubit<S> extends Cubit<BaseBlocState<S>>{
  BaseCubit(super.initialState);
}