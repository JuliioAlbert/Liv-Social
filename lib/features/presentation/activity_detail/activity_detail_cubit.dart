import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/domain/entities/activity.dart';

import 'package:liv_social/features/domain/usecases/manage_activity_usecase.dart';

class ActivityDetailCubit extends Cubit<ActivityDetailState> {
  ActivityDetailCubit(
    this._manageActivityUseCase,
    this.activity,
  ) : super(ActivityDetailInitialState());

  final ManageActivityUseCase _manageActivityUseCase;
  Activity activity;

  String title = '';
  String subtitle = '';
  String details = '';
  List<String> images = [];
  DateTime? expectedDate;
  LocationPlace? locationPlace;

  bool isFieldsValid() =>
      title.isNotEmpty &&
      subtitle.isNotEmpty &&
      details.isNotEmpty &&
      expectedDate != null &&
      locationPlace != null;

  void updateActivity() async {
    if (isFieldsValid()) {
      emit(ActivityDetailShowLoadingState());
      try {
        activity.title = title;
        activity.subtitle = subtitle;
        activity.details = details;
        activity.images = images;
        activity.expectedDate = expectedDate;
        activity.locationPlace = locationPlace!;

        await _manageActivityUseCase.createActivity(activity);
        emit(ActivityDetailHideLoadingState());
        emit(ActivityDetailShowLoadingState());
      } catch (e) {
        emit(ActivityDetailRegisterErrorState());
      }
    }
  }
}

abstract class ActivityDetailState extends Equatable {
  const ActivityDetailState();

  @override
  List<Object> get props => [];
}

class ActivityDetailInitialState extends ActivityDetailState {}

class ActivityDetailShowLoadingState extends ActivityDetailState {}

class ActivityDetailHideLoadingState extends ActivityDetailState {}

class ActivityDetailRegisterSuccessState extends ActivityDetailState {}

class ActivityDetailRegisterErrorState extends ActivityDetailState {}
