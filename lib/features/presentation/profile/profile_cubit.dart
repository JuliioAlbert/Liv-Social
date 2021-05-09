import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:liv_social/features/presentation/home/home_cubit.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._homeCubit,
  ) : super(ProfileInitialState());

  final HomeCubit _homeCubit;

  void logout() => _homeCubit.logout();
}

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}
