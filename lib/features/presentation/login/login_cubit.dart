import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:liv_social/core/utils/utils.dart';
import 'package:liv_social/features/data/models/auth_type.dart';
import 'package:liv_social/features/domain/entities/user_model.dart';
import 'package:liv_social/features/domain/usecases/login_usecase.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this._loginUseCase,
  ) : super(LoginInitialState());

  final LoginUseCase _loginUseCase;

  String _email = '';
  String _password = '';
  bool obscurePassword = true;

  set email(String text) {
    _email = text;
    emit(LoginUpdateFieldState(text: text));
  }

  set password(String text) {
    _password = text;
    emit(LoginUpdateFieldState(text: text));
  }

  bool get enableBtnContinue {
    return !Utils.isNullOrEmpty(_email) &&
        !Utils.isNullOrEmpty(_password) &&
        Utils.isValidEmail(_email) &&
        Utils.isValidPasswordLength(_password);
  }

  void updateObscureText(bool active) {
    obscurePassword = active;
    emit(LoginChangeObscureState(obscureText: active));
  }

  void login(AuthType authType) async {
    emit(LoginShowLoadingState());
    try {
      UserModel userModel;
      switch (authType) {
        case AuthType.Google:
          userModel = await _loginUseCase.signIn(authType);
          break;
        default:
          userModel = await _loginUseCase.signIn(authType,
              email: _email, password: _password);
      }
      emit(LoginHideLoadingState());
      emit(LoginUserLoggedState(userModel));
    } catch (e) {
      emit(LoginErrorState());
    }
  }
}

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginUserLoggedState extends LoginState {
  final UserModel user;

  LoginUserLoggedState(this.user);
  @override
  List<Object> get props => [user];
}

class LoginShowLoadingState extends LoginState {}

class LoginHideLoadingState extends LoginState {}

class LoginErrorState extends LoginState {}

class LoginChangeObscureState extends LoginState {
  final bool obscureText;
  LoginChangeObscureState({
    required this.obscureText,
  });

  @override
  List<Object> get props => [obscureText];
}

class LoginUpdateFieldState extends LoginState {
  final String text;
  LoginUpdateFieldState({
    required this.text,
  });

  @override
  List<Object> get props => [text];
}
