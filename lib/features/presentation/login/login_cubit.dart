import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:liv_social/core/utils/utils.dart';
import 'package:liv_social/features/data/models/auth_type.dart';
import 'package:liv_social/features/domain/usecases/login_usecase.dart';
import 'package:liv_social/features/domain/usecases/logout_usecase.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this._loginUseCase,
    this._logOutUseCase,
  ) : super(LoginInitialState());

  final LoginUseCase _loginUseCase;
  final LogOutUseCase _logOutUseCase;

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

  void login(AuthType authType) {
    switch (authType) {
      case AuthType.Google:
        _loginUseCase.signIn(authType);
        break;
      default:
        _loginUseCase.signIn(authType, email: _email, password: _password);
    }
  }

  void logOut() {
    _logOutUseCase.logout();
  }
}

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

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
