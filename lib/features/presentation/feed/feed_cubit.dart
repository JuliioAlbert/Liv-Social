import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/usecases/get_activities_usecase.dart';
import 'package:liv_social/features/presentation/home/home_cubit.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(
    this.homeCubit,
    this._getActiviesUseCase,
  ) : super(FeedInitialState()) {
    homeSubscription = homeCubit.stream.listen((state) {
      if (state is HomeReloadFeedState) {
        emit(FeedInitialState());
        getFeedActivities();
      }
    });
  }

  final HomeCubit homeCubit;

  final GetActiviesUseCase _getActiviesUseCase;
  StreamSubscription? homeSubscription;

  List<Activity>? activities;

  void getFeedActivities() async {
    try {
      activities = await _getActiviesUseCase.getActivities();
      emit(FeedActivitiesLoadedState(activities));
    } catch (e) {
      emit(FeedActivitiesErrorState());
    }
  }
}

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitialState extends FeedState {}

class FeedActivitiesLoadedState extends FeedState {
  final List<Activity>? activities;

  FeedActivitiesLoadedState(this.activities);

  @override
  List<Object?> get props => [activities];
}

class FeedActivitiesErrorState extends FeedState {}
