import 'package:firebase_auth/firebase_auth.dart';
import 'package:liv_social/features/data/models/auth_type.dart';
import 'package:liv_social/features/domain/entities/user_model.dart';

abstract class AuthRepository {
  /// Get current authentication [User]
  /// Throws a [NotAuthException] if there is no current user authentication
  Future<User> getAuthUser();

  /// Authenticate and return the user's [UserModel]
  /// Throws:
  ///   [LogInWithEmailAndPasswordFailure] if the authentication with email and password fails
  ///   [LogInWithGoogleFailure] if the authentication with google fails
  ///   [LogInGetCredentialFailure] if the [UserModel] could not be obtained
  Future<UserModel> signIn(AuthType authType,
      {String? email, String? password});

  /// Create an user with email and password and return [UserCredential]
  Future<UserCredential> createUserByEmailAuth(String email, String password);

  /// Log out the user
  /// Throw [LogOutFailure] when it fails
  Future<void> logout();
}
