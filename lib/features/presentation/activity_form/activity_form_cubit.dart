import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/data/models/place.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/repositories/image_picker_repository.dart';

import 'package:liv_social/features/domain/usecases/login_usecase.dart';
import 'package:liv_social/features/domain/usecases/manage_activity_usecase.dart';

class ActivityFormCubit extends Cubit<ActivityFormState> {
  ActivityFormCubit(
    this._manageActivityUseCase,
    this._loginUseCase,
    this._imagePickerRepository,
  )   : now = DateTime.now(),
        lastDate = DateTime.now().add(const Duration(days: 60)),
        super(ActivityFormInitialState()) {
    ;
  }

  final ManageActivityUseCase _manageActivityUseCase;
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
      emit(ActivityFormShowLoadingState());
      try {
        final userSession = _loginUseCase.user!;
        await _manageActivityUseCase.createActivity(
            Activity(
              userSession.uid,
              userSession.name,
              title,
              subtitle,
              details,
              expectedDate,
              locationPlace!,
            ),
            image);
        emit(ActivityFormHideLoadingState());
        emit(ActivityFormRegisterSuccessState());
      } catch (e) {
        emit(ActivityFormRegisterErrorState());
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
    emit(ActivityFormDateTimeUpdatedState(expectedDate));
  }

  void updateLocationPlace(Place? place) {
    if (place != null) {
      try {
        locationPlace = LocationPlace(place.name, place.address,
            place.latLng.latitude, place.latLng.longitude);
        emit(ActivityFormPlaceUpdateState(locationPlace!));
      } catch (e) {
        emit(ActivityFormUpdatePlaceErrorState());
      }
    }
  }

  void pickImage() async {
    image = await _imagePickerRepository.pickImage();
    emit(ActivityFormImageSelectedState(image));
  }

  void exit() {
    emit(ActivityFormInitialState());
    emit(ActivityFormExitRequestState());
  }
}

abstract class ActivityFormState extends Equatable {
  const ActivityFormState();

  @override
  List<Object?> get props => [];
}

class ActivityFormInitialState extends ActivityFormState {}

class ActivityFormShowLoadingState extends ActivityFormState {}

class ActivityFormHideLoadingState extends ActivityFormState {}

class ActivityFormRegisterSuccessState extends ActivityFormState {}

class ActivityFormRegisterErrorState extends ActivityFormState {}

class ActivityFormImageSelectedState extends ActivityFormState {
  final File? image;

  ActivityFormImageSelectedState(this.image);

  @override
  List<Object?> get props => [image];
}

class ActivityFormDateTimeUpdatedState extends ActivityFormState {
  final DateTime? date;

  ActivityFormDateTimeUpdatedState(this.date);

  @override
  List<Object?> get props => [date];
}

class ActivityFormPlaceUpdateState extends ActivityFormState {
  final LocationPlace place;

  ActivityFormPlaceUpdateState(this.place);

  @override
  List<Object> get props => [place];
}

class ActivityFormUpdatePlaceErrorState extends ActivityFormState {}

class ActivityFormExitRequestState extends ActivityFormState {}
