import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/data/models/place.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/repositories/image_picker_repository.dart';
import 'package:liv_social/features/domain/usecases/create_activity_usecase.dart';

import 'package:liv_social/features/domain/usecases/login_usecase.dart';

class ActivityCreateCubit extends Cubit<ActivityCreateState> {
  ActivityCreateCubit(
    this._createActivityUseCase,
    this._loginUseCase,
    this._imagePickerRepository,
  )   : now = DateTime.now(),
        lastDate = DateTime.now().add(const Duration(days: 60)),
        super(ActivityCreateInitialState());

  final CreateActivityUseCase _createActivityUseCase;
  final ImagePickerRepository _imagePickerRepository;
  final LoginUseCase _loginUseCase;

  String title = '';
  String subtitle = '';
  String details = '';
  File? image;
  DateTime? expectedDate;
  TimeOfDay? expectedTime;
  LocationPlace? locationPlace;
  final DateTime now;
  final DateTime lastDate;

  bool isFieldsValid() =>
      title.isNotEmpty &&
      subtitle.isNotEmpty &&
      details.isNotEmpty &&
      expectedDate != null &&
      locationPlace != null;

  void createActivity() async {
    if (isFieldsValid()) {
      emit(ActivityCreateShowLoadingState());
      try {
        final userSession = _loginUseCase.user!;
        await _createActivityUseCase.createActivity(
          Activity(
            ownerId: userSession.uid,
            ownerName: userSession.name,
            title: title,
            subtitle: subtitle,
            details: details,
            expectedDate: expectedDate,
            locationPlace: locationPlace!,
          ),
          image,
        );
        emit(ActivityCreateHideLoadingState());
        emit(ActivityCreateRegisterSuccessState());
      } catch (e) {
        emit(ActivityCreateHideLoadingState());
        emit(ActivityCreateRegisterErrorState());
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
      expectedDate = DateTime(expectedDate!.year, expectedDate!.month,
          expectedDate!.day, time.hour, time.minute);
    } else {
      expectedDate = null;
      time = null;
    }
    emit(ActivityCreateDateTimeUpdatedState(expectedDate));
  }

  void updateLocationPlace(Place? place) {
    if (place != null) {
      try {
        locationPlace = LocationPlace(
            name: place.name,
            address: place.address,
            latitude: place.latLng.latitude,
            longitude: place.latLng.longitude);
        emit(ActivityCreatePlaceUpdateState(locationPlace!));
      } catch (e) {
        emit(ActivityCreateUpdatePlaceErrorState());
      }
    }
  }

  Future<void> pickImage() async {
    image = await _imagePickerRepository.pickImage();
    emit(ActivityCreateImageSelectedState(image));
  }

  void exit() {
    emit(ActivityCreateInitialState());
    emit(ActivityCreateExitRequestState());
  }
}

abstract class ActivityCreateState extends Equatable {
  const ActivityCreateState();

  @override
  List<Object?> get props => [];
}

class ActivityCreateInitialState extends ActivityCreateState {}

class ActivityCreateShowLoadingState extends ActivityCreateState {}

class ActivityCreateHideLoadingState extends ActivityCreateState {}

class ActivityCreateRegisterSuccessState extends ActivityCreateState {}

class ActivityCreateRegisterErrorState extends ActivityCreateState {}

class ActivityCreateImageSelectedState extends ActivityCreateState {
  final File? image;

  ActivityCreateImageSelectedState(this.image);

  @override
  List<Object?> get props => [image];
}

class ActivityCreateDateTimeUpdatedState extends ActivityCreateState {
  final DateTime? date;

  ActivityCreateDateTimeUpdatedState(this.date);

  @override
  List<Object?> get props => [date];
}

class ActivityCreatePlaceUpdateState extends ActivityCreateState {
  final LocationPlace place;

  ActivityCreatePlaceUpdateState(this.place);

  @override
  List<Object> get props => [place];
}

class ActivityCreateUpdatePlaceErrorState extends ActivityCreateState {}

class ActivityCreateExitRequestState extends ActivityCreateState {}
