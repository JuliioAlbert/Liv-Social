import 'package:firebase_auth/firebase_auth.dart';
import 'package:liv_social/features/data/models/auth_type.dart';
import 'package:liv_social/features/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> getAuthUser();
  Future<UserModel> signIn(AuthType authType,
      {String? email, String? password});
  Future<UserCredential> createUserByEmailAuth(String email, String password);
  Future<void> logout();
}
