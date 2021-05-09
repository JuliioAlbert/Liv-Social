import 'package:liv_social/core/exceptions/account_exception.dart';
import 'package:liv_social/features/data/models/auth_type.dart';
import 'package:liv_social/features/data/models/user_model.dart';
import 'package:liv_social/features/domain/repositories/account_repository.dart';
import 'package:liv_social/features/domain/repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._authRepository, this._accountRepository);

  final AuthRepository _authRepository;
  final AccountRepository _accountRepository;

  Future<bool> validateSession() async {
    await _authRepository.getAuthUser();
    return true;
  }

  Future<UserModel> signIn(
    AuthType authType, {
    String? email,
    String? password,
  }) async {
    UserModel? authUser;
    try {
      authUser = await _authRepository.signIn(
        authType,
        email: email,
        password: password,
      );

      return await _accountRepository.findUserById(authUser.uid);
    } on UserNotExist {
      return await _accountRepository.registerUser(authUser!);
    }
  }
}
