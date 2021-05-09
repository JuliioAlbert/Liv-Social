import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/domain/entities/activity.dart';

import 'package:liv_social/features/domain/usecases/login_usecase.dart';
import 'package:liv_social/features/domain/usecases/manage_activity_usecase.dart';

class ActivityFormCubit extends Cubit<ActivityState> {
  ActivityFormCubit(
    this._manageActivityUseCase,
    this._loginUseCase,
  ) : super(ActivityInitialState());

  final ManageActivityUseCase _manageActivityUseCase;
  final LoginUseCase _loginUseCase;

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

  void createActivity() async {
    if (isFieldsValid()) {
      emit(ActivityShowLoadingState());
      try {
        final userSession = _loginUseCase.user!;
        await _manageActivityUseCase.createActivity(Activity(
          userSession.uid,
          userSession.name,
          title,
          subtitle,
          details,
          images,
          expectedDate,
          locationPlace!,
        ));
        emit(ActivityHideLoadingState());
        emit(ActivityShowLoadingState());
      } catch (e) {
        emit(ActivityRegisterErrorState());
      }
    }
  }
}

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class ActivityInitialState extends ActivityState {}

class ActivityShowLoadingState extends ActivityState {}

class ActivityHideLoadingState extends ActivityState {}

class ActivityRegisterSuccessState extends ActivityState {}

class ActivityRegisterErrorState extends ActivityState {}
