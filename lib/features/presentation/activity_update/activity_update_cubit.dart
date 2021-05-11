import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/data/models/place.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/repositories/image_picker_repository.dart';
import 'package:liv_social/features/domain/usecases/update_activity_usecase.dart';

class ActivityUpdateCubit extends Cubit<ActivityUpdateState> {
  ActivityUpdateCubit(
    this._updateActivityUseCase,
    this._imagePickerRepository,
    this.activity,
  )   : now = DateTime.now(),
        lastDate = DateTime.now().add(const Duration(days: 60)),
        super(ActivityUpdateInitialState());

  final UpdateActivityUseCase _updateActivityUseCase;
  final ImagePickerRepository _imagePickerRepository;
  Activity activity;

  File? image;
  DateTime? expectedDate;
  TimeOfDay? expectedTime;
  final DateTime now;
  final DateTime lastDate;

  bool isFieldsValid() =>
      activity.title.isNotEmpty &&
      activity.subtitle.isNotEmpty &&
      activity.details.isNotEmpty &&
      activity.expectedDate != null;

  void updateActivity() async {
    if (isFieldsValid()) {
      emit(ActivityUpdateShowLoadingState());
      try {
        await _updateActivityUseCase.updateActivity(
          activity,
          image,
        );
        emit(ActivityUpdateHideLoadingState());
        emit(ActivityUpdateSuccessState(activity));
      } catch (e) {
        emit(ActivityUpdateHideLoadingState());
        emit(ActivityUpdateRegisterErrorState());
      }
    }
  }

  bool updateExpectedDate(DateTime? date) {
    if (date != null) {
      expectedDate = date;
      return true;
    } else {
      return false;
    }
  }

  void updateExpectedTime(TimeOfDay? time) {
    if (time != null) {
      expectedTime = time;
      activity.expectedDate = DateTime(expectedDate!.year, expectedDate!.month,
          expectedDate!.day, time.hour, time.minute);
    } else {
      expectedDate = null;
      time = null;
    }
    emit(ActivityUpdateDateTimeUpdatedState(expectedDate));
  }

  void updateLocationPlace(Place? place) {
    if (place != null) {
      try {
        activity.locationPlace = LocationPlace(place.name, place.address,
            place.latLng.latitude, place.latLng.longitude);
        emit(ActivityUpdatePlaceUpdateState(activity.locationPlace));
      } catch (e) {
        emit(ActivityUpdateUpdatePlaceErrorState());
      }
    }
  }

  void pickImage() async {
    image = await _imagePickerRepository.pickImage();
    emit(ActivityUpdateImageSelectedState(image));
  }

  void exit() {
    emit(ActivityUpdateInitialState());
    emit(ActivityUpdateExitRequestState());
  }
}

abstract class ActivityUpdateState extends Equatable {
  const ActivityUpdateState();

  @override
  List<Object?> get props => [];
}

class ActivityUpdateInitialState extends ActivityUpdateState {}

class ActivityUpdateShowLoadingState extends ActivityUpdateState {}

class ActivityUpdateHideLoadingState extends ActivityUpdateState {}

class ActivityUpdateSuccessState extends ActivityUpdateState {
  final Activity activity;

  ActivityUpdateSuccessState(this.activity);

  @override
  List<Object?> get props => [activity];
}

class ActivityUpdateRegisterErrorState extends ActivityUpdateState {}

class ActivityUpdateImageSelectedState extends ActivityUpdateState {
  final File? image;

  ActivityUpdateImageSelectedState(this.image);

  @override
  List<Object?> get props => [image];
}

class ActivityUpdateDateTimeUpdatedState extends ActivityUpdateState {
  final DateTime? date;

  ActivityUpdateDateTimeUpdatedState(this.date);

  @override
  List<Object?> get props => [date];
}

class ActivityUpdatePlaceUpdateState extends ActivityUpdateState {
  final LocationPlace place;

  ActivityUpdatePlaceUpdateState(this.place);

  @override
  List<Object> get props => [place];
}

class ActivityUpdateUpdatePlaceErrorState extends ActivityUpdateState {}

class ActivityUpdateExitRequestState extends ActivityUpdateState {}
