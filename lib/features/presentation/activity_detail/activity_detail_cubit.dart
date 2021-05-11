import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/usecases/login_usecase.dart';
import 'package:liv_social/features/presentation/home/home_cubit.dart';

class ActivityDetailCubit extends Cubit<ActivityDetailState> {
  ActivityDetailCubit(this.activity, this._loginUseCase, this._homeCubit)
      : super(ActivityDetailInitialState());

  Activity activity;
  final LoginUseCase _loginUseCase;
  final HomeCubit _homeCubit;

  bool get isOwner => _loginUseCase.user!.uid == activity.ownerId;

  void processUpdate(Object? activity) {
    if (activity != null && activity is Activity) {
      _homeCubit.reloadFeed();
      emit(ActivityDetailUpdatedState(activity));
    }
  }
}

abstract class ActivityDetailState extends Equatable {
  const ActivityDetailState();

  @override
  List<Object> get props => [];
}

class ActivityDetailInitialState extends ActivityDetailState {}

class ActivityDetailUpdatedState extends ActivityDetailState {
  final Activity activity;

  ActivityDetailUpdatedState(this.activity);

  @override
  List<Object> get props => [activity];
}
