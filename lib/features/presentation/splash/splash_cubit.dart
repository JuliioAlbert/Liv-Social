import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/domain/usecases/login_usecase.dart';

enum SplashState {
  none,
  session_user,
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(
    this._loginUseCase,
  ) : super(SplashState.none);

  final LoginUseCase _loginUseCase;

  void init() async {
    final result = await _loginUseCase.validateSession();
    if (result) {
      emit(SplashState.session_user);
    } else {
      emit(SplashState.none);
    }
  }
}
