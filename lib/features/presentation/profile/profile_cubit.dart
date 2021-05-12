import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:liv_social/features/domain/entities/user_model.dart';
import 'package:liv_social/features/presentation/home/home_cubit.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._homeCubit,
    this.user,
  ) : super(ProfileInitialState());

  final HomeCubit _homeCubit;
  final UserModel user;

  void logout() => _homeCubit.logout();
}

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}
