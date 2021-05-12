import 'package:liv_social/core/exceptions/account_exception.dart';
import 'package:liv_social/core/exceptions/auth_exception.dart';
import 'package:liv_social/features/data/models/auth_type.dart';
import 'package:liv_social/features/domain/entities/user_model.dart';
import 'package:liv_social/features/domain/repositories/account_repository.dart';
import 'package:liv_social/features/domain/repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._authRepository, this._accountRepository);

  final AuthRepository _authRepository;
  final AccountRepository _accountRepository;

  bool isLoggedIn = false;
  UserModel? user;

  Future<bool> validateSession() async {
    try {
      final userAuth = await _authRepository.getAuthUser();
      user = await _accountRepository.findUserById(userAuth.uid);
      isLoggedIn = true;
    } on NotAuthException {
      return false;
    }
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

      user = await _accountRepository.findUserById(authUser.uid);
      return user!;
    } on UserNotExist {
      return await _accountRepository.registerUser(authUser!);
    }
  }
}
